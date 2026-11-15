begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-sv-h-3.3-a-v2','apcalcbc-mcq-b2-sv-h-3.3-a-v3','apcalcbc-mcq-b2-h-3.3-b','apcalcbc-mcq-b2-sv-h-3.3-b-v1','apcalcbc-mcq-b2-sv-h-3.3-b-v2','apcalcbc-mcq-b2-sv-h-3.3-b-v3','apcalcbc-mcq-b2-h-3.4-a','apcalcbc-mcq-b2-sv-h-3.4-a-v1','apcalcbc-mcq-b2-sv-h-3.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b2-sv-h-3.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.3-a-v2', 'mcq', 'differentiate a composition or product involving an inverse function, using table values of f only. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is differentiable and one-to-one, with the values below. Let g = f⁻¹ and h(x) = (g(x))².
x | f(x) | f′(x)
1 | 3 | 4
2 | 5 | 6
What is h′(5)?', null, md5('apcalcbc-mcq-b2-sv-h-3.3-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24', false, 'This replaces g′(5) by f′(2) = 6, so the inverse derivative is not taken as a reciprocal.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/6', false, 'This gives g′(5) alone and omits the power-rule factor 2g(5) from differentiating the square.' from version_ins
union all select gen_random_uuid(), id, 'C', '2/3', true, 'Correct: g(5) = 2 because f(2) = 5, and g′(5) = 1/f′(2) = 1/6. Then h′(5) = 2·g(5)·g′(5) = 2·2/6 = 2/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/3', false, 'This keeps the factor 2 and g′(5) but omits the factor g(5) = 2 from the power rule.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.3-a-v3', 'mcq', 'differentiate a composition or product involving an inverse function, using table values of f only. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is differentiable and one-to-one, with the values below. Let g = f⁻¹ and h(x) = g(x²).
x | f(x) | f′(x)
2 | 4 | 5
3 | 7 | 3
What is h′(2)?', null, md5('apcalcbc-mcq-b2-sv-h-3.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/5', true, 'Correct: g(4) = 2 because f(2) = 4, so g′(4) = 1/f′(2) = 1/5. Then h′(2) = g′(2²)·2·2 = 4/5.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/5', false, 'This finds g′(4) but omits the chain-rule factor 2x = 4 from the inner function x².' from version_ins
union all select gen_random_uuid(), id, 'C', '20', false, 'This multiplies by f′(2) instead of dividing: the inverse derivative is the reciprocal 1/f′(g(4)).' from version_ins
union all select gen_random_uuid(), id, 'D', '4/3', false, 'This evaluates f′ at 3 instead of at g(4) = 2, so the wrong table row is used.' from version_ins;
-- apcalcbc-mcq-b2-h-3.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.3-b', 'mcq', 'find the second derivative of an inverse function, differentiating 1/f′(x) again with respect to y.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³ + x, which is one-to-one. What is (f⁻¹)″(2)?', null, md5('apcalcbc-mcq-b2-h-3.3-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/32', false, 'This loses the minus sign: differentiating 1/f′(x) with respect to y gives −f″(x)/(f′(x))³, which is negative here.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/8', false, 'This uses −f″/(f′)² and forgets that a second factor of 1/f′ comes from the chain rule through x = f⁻¹(y).' from version_ins
union all select gen_random_uuid(), id, 'C', '1/6', false, 'This takes 1/f″(1) as if the second derivative of the inverse were the reciprocal of the second derivative.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3/32', true, 'Correct: f(1) = 2, f′(1) = 4, f″(1) = 6. (f⁻¹)′(y) = 1/f′(x), so (f⁻¹)″(y) = −f″(x)·(dx/dy)/(f′(x))² = −f″(x)/(f′(x))³ = −6/64 = −3/32.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.3-b-v1', 'mcq', 'find the second derivative of an inverse function, differentiating 1/f′(x) again with respect to y. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³ + 2x, which is one-to-one. What is (f⁻¹)″(3)?', null, md5('apcalcbc-mcq-b2-sv-h-3.3-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6/125', false, 'This loses the minus sign: the derivative of 1/f′(x) with respect to y is −f″/(f′)³.' from version_ins
union all select gen_random_uuid(), id, 'B', '−6/25', false, 'This uses −f″/(f′)² and omits the extra factor 1/f′ that arises because x depends on y.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/5', false, 'This is the first derivative (f⁻¹)′(3) = 1/f′(1), not the second derivative.' from version_ins
union all select gen_random_uuid(), id, 'D', '−6/125', true, 'Correct: f(1) = 3, f′(1) = 5, f″(1) = 6. Then (f⁻¹)″(3) = −f″(1)/(f′(1))³ = −6/125.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.3-b-v2', 'mcq', 'find the second derivative of an inverse function, differentiating 1/f′(x) again with respect to y. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = eˣ + x, which is one-to-one. What is (f⁻¹)″(1)?', null, md5('apcalcbc-mcq-b2-sv-h-3.3-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/8', false, 'This loses the minus sign from differentiating 1/f′(x): the second derivative of the inverse is −f″/(f′)³.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/4', false, 'This uses −f″/(f′)² and forgets the extra factor 1/f′ from the chain rule through x = f⁻¹(y).' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/8', true, 'Correct: f(0) = 1, f′(0) = e⁰ + 1 = 2, f″(0) = e⁰ = 1. Then (f⁻¹)″(1) = −f″(0)/(f′(0))³ = −1/8.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This is the first derivative (f⁻¹)′(1) = 1/f′(0), not the second derivative.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.3-b-v3', 'mcq', 'find the second derivative of an inverse function, differentiating 1/f′(x) again with respect to y. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is twice differentiable and one-to-one, with f(2) = 7, f′(2) = 4 and f″(2) = −2. What is (f⁻¹)″(7)?', null, md5('apcalcbc-mcq-b2-sv-h-3.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/32', false, 'This loses the minus sign: the formula is (f⁻¹)″ = −f″/(f′)³, and f″(2) is itself negative, so the result is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/8', false, 'This uses −f″/(f′)² and forgets the extra factor 1/f′ that comes from the chain rule through x = f⁻¹(y).' from version_ins
union all select gen_random_uuid(), id, 'C', '1/32', true, 'Correct: (f⁻¹)′(y) = 1/f′(x), so (f⁻¹)″(y) = −f″(x)/(f′(x))³ with x = f⁻¹(7) = 2: −(−2)/64 = 1/32.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/4', false, 'This is the first derivative (f⁻¹)′(7) = 1/f′(2), not the second derivative.' from version_ins;
-- apcalcbc-mcq-b2-h-3.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.4-a', 'mcq', 'differentiate an inverse trigonometric function of a reciprocal or quadratic on a restricted domain, keeping the correct', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x < −1, let f(x) = cos⁻¹(1/x). What is f′(−2)?', null, md5('apcalcbc-mcq-b2-h-3.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√3/6', true, 'Correct: f′(x) = [−1/√(1 − 1/x²)]·(−1/x²) = 1/(x²√(1 − 1/x²)). At x = −2: 1/(4·√(3/4)) = 1/(2√3) = √3/6, which is positive because the factor −1/x² is negative and cos⁻¹ is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', '−√3/6', false, 'This applies the simplified formula 1/(x√(x² − 1)) at x = −2; that formula holds for x > 1, and for x < −1 the correct form has |x|, so the sign is wrong.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2/√3', false, 'This omits the chain-rule factor −1/x² from the inner function 1/x, so only the outer derivative −1/√(1 − 1/4) is evaluated.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/√3', false, 'This omits the chain-rule factor −1/x² and also uses the derivative of sin⁻¹ instead of the negative derivative of cos⁻¹.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.4-a-v1', 'mcq', 'differentiate an inverse trigonometric function of a reciprocal or quadratic on a restricted domain, keeping the correct (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x < −1, let f(x) = sin⁻¹(1/x). What is f′(−3)?', null, md5('apcalcbc-mcq-b2-sv-h-3.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√2/12', false, 'This applies −1/(x√(x² − 1)), which is valid only for x > 1; at x = −3 it gives the wrong sign because the correct form uses |x|.' from version_ins
union all select gen_random_uuid(), id, 'B', '3√2/4', false, 'This omits the chain-rule factor −1/x² and keeps only the outer derivative 1/√(1 − 1/9).' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/9', false, 'This keeps the chain factor −1/x² but leaves out the outer factor 1/√(1 − 1/x²).' from version_ins
union all select gen_random_uuid(), id, 'D', '−√2/12', true, 'Correct: f′(x) = [1/√(1 − 1/x²)]·(−1/x²). At x = −3: (1/√(8/9))·(−1/9) = (3/(2√2))(−1/9) = −1/(6√2) = −√2/12.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.4-a-v2', 'mcq', 'differentiate an inverse trigonometric function of a reciprocal or quadratic on a restricted domain, keeping the correct (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For −√2 < x < 0, let f(x) = cos⁻¹(x² − 1). Which expression equals f′(x)?', null, md5('apcalcbc-mcq-b2-sv-h-3.4-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2/√(2 − x²)', false, 'This simplifies √(2x² − x⁴) as x√(2 − x²), but x is negative here, so √(x²) = −x and the sign is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', '2/√(2 − x²)', true, 'Correct: f′(x) = −2x/√(1 − (x² − 1)²) = −2x/√(2x² − x⁴) = −2x/(|x|√(2 − x²)). For x < 0, |x| = −x, so f′(x) = 2/√(2 − x²), which is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', '2x/√(2 − x²)', false, 'This drops the factor x in the denominator when simplifying but keeps the factor 2x from the chain rule, so x does not cancel.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/√(1 − x²)', false, 'This forgets that 1 − (x² − 1)² = 2x² − x⁴, not 1 − x²; the radicand is 2 − x² after factoring out x².' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-sv-h-3.3-a-v2','apcalcbc-mcq-b2-sv-h-3.3-a-v3','apcalcbc-mcq-b2-h-3.3-b','apcalcbc-mcq-b2-sv-h-3.3-b-v1','apcalcbc-mcq-b2-sv-h-3.3-b-v2','apcalcbc-mcq-b2-sv-h-3.3-b-v3','apcalcbc-mcq-b2-h-3.4-a','apcalcbc-mcq-b2-sv-h-3.4-a-v1','apcalcbc-mcq-b2-sv-h-3.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b2-sv-h-3.3-a-v2','apcalcbc-mcq-b2-sv-h-3.3-a-v3','apcalcbc-mcq-b2-h-3.3-b','apcalcbc-mcq-b2-sv-h-3.3-b-v1','apcalcbc-mcq-b2-sv-h-3.3-b-v2','apcalcbc-mcq-b2-sv-h-3.3-b-v3','apcalcbc-mcq-b2-h-3.4-a','apcalcbc-mcq-b2-sv-h-3.4-a-v1','apcalcbc-mcq-b2-sv-h-3.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
