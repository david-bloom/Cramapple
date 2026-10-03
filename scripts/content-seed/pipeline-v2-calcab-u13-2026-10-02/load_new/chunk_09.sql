begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u3n-008-v3','apcalcab-mcq-u3n-009-v1','apcalcab-mcq-u3n-009-v2','apcalcab-mcq-u3n-009-v3','apcalcab-mcq-u3n-010-v1','apcalcab-mcq-u3n-010-v2','apcalcab-mcq-u3n-010-v3','apcalcab-mcq-u3n-011-v1','apcalcab-mcq-u3n-011-v2','apcalcab-mcq-u3n-011-v3','apcalcab-mcq-u3n-012-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u3n-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-008-v3', 'mcq', 'Inverse slope for a decreasing function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function h is differentiable and one-to-one, with h(1) = 8, h(2) = 5, h(3) = 2, h′(1) = −4, h′(2) = −6, and h′(3) = −8. What is (h⁻¹)′(2)?', null, md5('apcalcab-mcq-u3n-008-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−8', false, 'This is h′(3), the derivative of h rather than of h⁻¹. The derivative of the inverse is the reciprocal, −1/8.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/8', true, 'h(3) = 2, so h⁻¹(2) = 3, and (h⁻¹)′(2) = 1/h′(h⁻¹(2)) = 1/h′(3) = −1/8.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/8', false, 'This takes the reciprocal of 8 but drops the negative sign, assuming the inverse must be increasing. Since h is decreasing, h⁻¹ is decreasing too: 1/h′(3) = 1/(−8) = −1/8.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/6', false, 'This uses 1/h′(2) = 1/(−6), plugging the input 2 into h′. The formula requires h′ at h⁻¹(2) = 3, where h′(3) = −8, so the value is −1/8.' from version_ins;
-- apcalcab-mcq-u3n-009-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-009-v1', 'mcq', 'Inverse derivative for a cubic polynomial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f(x) = x³ + 4x − 2 is one-to-one. Find (f⁻¹)′(3).', null, md5('apcalcab-mcq-u3n-009-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/31', false, 'This uses 1/f′(3) = 1/(3 · 9 + 4) = 1/31, evaluating f′ at 3. The formula needs f′ at f⁻¹(3) = 1, where f′(1) = 7.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This is f′(1), the slope of f at the matching point. The slope of f⁻¹ is its reciprocal, 1/7.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/7', true, 'f(1) = 1 + 4 − 2 = 3, so f⁻¹(3) = 1. Since f′(x) = 3x² + 4, f′(1) = 7, and (f⁻¹)′(3) = 1/f′(1) = 1/7.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/3', false, 'This takes the reciprocal of the value f(1) = 3. The reciprocal must be of the derivative f′(1) = 7, not of the function value.' from version_ins;
-- apcalcab-mcq-u3n-009-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-009-v2', 'mcq', 'Inverse derivative with an exponential function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = e^x + 3x, which is one-to-one. What is (f⁻¹)′(1)?', null, md5('apcalcab-mcq-u3n-009-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', false, 'This is f′(0), the slope of f at the matching point. The slope of f⁻¹ is its reciprocal, 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/3', false, 'This evaluates e⁰ as 0, so f′(0) = 0 + 3 = 3 and the result is 1/3. Since e⁰ = 1, f′(0) = 1 + 3 = 4 and the value is 1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/4', true, 'f(0) = e⁰ + 0 = 1, so f⁻¹(1) = 0. Since f′(x) = e^x + 3, f′(0) = 4, and (f⁻¹)′(1) = 1/f′(0) = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/(e + 3)', false, 'This uses 1/f′(1) = 1/(e + 3), evaluating f′ at 1. The formula needs f′ at f⁻¹(1) = 0, where f′(0) = 4.' from version_ins;
-- apcalcab-mcq-u3n-009-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-009-v3', 'mcq', 'Inverse derivative with a restricted domain', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f(x) = x² + 3x is defined for x ≥ 0, so it is one-to-one on that domain. What is (f⁻¹)′(10)?', null, md5('apcalcab-mcq-u3n-009-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/23', false, 'This uses 1/f′(10) = 1/(2 · 10 + 3) = 1/23, evaluating f′ at 10. The formula needs f′ at f⁻¹(10) = 2, where f′(2) = 7.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This is f′(2), the slope of f at the matching point. The slope of f⁻¹ is its reciprocal, 1/7.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/7', false, 'This uses the root x = −5 of x² + 3x = 10, which is outside the domain x ≥ 0. Then f′(−5) = −7 and 1/f′(−5) = −1/7. The domain requires x = 2, giving 1/7.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/7', true, 'Solve x² + 3x = 10: (x + 5)(x − 2) = 0, and x ≥ 0 gives x = 2, so f⁻¹(10) = 2. Since f′(x) = 2x + 3, f′(2) = 7, and (f⁻¹)′(10) = 1/f′(2) = 1/7.' from version_ins;
-- apcalcab-mcq-u3n-010-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-010-v1', 'mcq', 'Slope of an inverse cosine curve', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find the slope of the tangent line to the graph of g(x) = cos⁻¹(3x) at x = 1/6.', null, md5('apcalcab-mcq-u3n-010-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2/√3', false, 'This is −1/√(1 − (3x)²) = −1/(√3/2) = −2/√3 at x = 1/6, with no chain-rule factor 3 from d/dx(3x). The correct value is −2√3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−6/√5', false, 'This uses −3/√(1 + (3x)²) = −3/√(5/4) = −6/√5, with a plus sign under the radical. The derivative of cos⁻¹ u has 1 − u² under the radical, giving −2√3.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2√3', true, 'g′(x) = −3/√(1 − (3x)²). At x = 1/6: 1 − 1/4 = 3/4, so g′(1/6) = −3/√(3/4) = −3/(√3/2) = −6/√3 = −2√3.' from version_ins
union all select gen_random_uuid(), id, 'D', '2√3', false, 'This uses +3/√(1 − (3x)²), the derivative of sin⁻¹(3x), and misses the negative sign of the derivative of cos⁻¹: 3/(√3/2) = 2√3. The correct value is −2√3.' from version_ins;
-- apcalcab-mcq-u3n-010-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-010-v2', 'mcq', 'Derivative of inverse sine with a fractional argument', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = sin⁻¹(x/3). Evaluate f′(3/2).', null, md5('apcalcab-mcq-u3n-010-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/(3√5)', false, 'This uses (1/3)/√(1 + (x/3)²) = (1/3)/√(5/4) = 2/(3√5), with a plus sign under the radical. The derivative of sin⁻¹ u has 1 − u² under the radical, giving 2/(3√3).' from version_ins
union all select gen_random_uuid(), id, 'B', '2/(3√3)', true, 'f′(x) = (1/3)/√(1 − (x/3)²). At x = 3/2: (x/3)² = 1/4, so f′(3/2) = (1/3)/√(3/4) = (1/3)/(√3/2) = 2/(3√3).' from version_ins
union all select gen_random_uuid(), id, 'C', '4/9', false, 'This drops the square root: (1/3)/(1 − 1/4) = (1/3)/(3/4) = 4/9. The derivative of sin⁻¹ u has √(1 − u²) in the denominator, giving 2/(3√3).' from version_ins
union all select gen_random_uuid(), id, 'D', '2/√3', false, 'This is 1/√(1 − (x/3)²) = 1/(√3/2) = 2/√3 at x = 3/2, with no chain-rule factor 1/3 from d/dx(x/3). The correct value is 2/(3√3).' from version_ins;
-- apcalcab-mcq-u3n-010-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-010-v3', 'mcq', 'Inverse sine of an exponential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = sin⁻¹(e^x), what is f′(−ln 2)?', null, md5('apcalcab-mcq-u3n-010-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/√3', true, 'f′(x) = e^x/√(1 − (e^x)²). At x = −ln 2, e^x = 1/2, so f′ = (1/2)/√(1 − 1/4) = (1/2)/(√3/2) = 1/√3.' from version_ins
union all select gen_random_uuid(), id, 'B', '√2/2', false, 'This writes 1 − e^x under the radical instead of 1 − (e^x)²: (1/2)/√(1 − 1/2) = (1/2)/(√2/2) = √2/2. The inside function must be squared, giving 1/√3.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/√5', false, 'This uses (1/2)/√(1 + 1/4) = (1/2)/(√5/2) = 1/√5, with a plus sign under the radical. The derivative of sin⁻¹ u has 1 − u² under the radical, giving 1/√3.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/√3', false, 'This is 1/√(1 − (e^x)²) = 1/(√3/2) = 2/√3, with no chain-rule factor e^x = 1/2 from the inner function. The correct value is 1/√3.' from version_ins;
-- apcalcab-mcq-u3n-011-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-011-v1', 'mcq', 'Derivative of inverse tangent of an exponential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find f′(x) when f(x) = tan⁻¹(e^x).', null, md5('apcalcab-mcq-u3n-011-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e^x/(1 + e^(2x))', true, 'd/dx tan⁻¹ u = u′/(1 + u²) with u = e^x, u′ = e^x, so f′(x) = e^x/(1 + (e^x)²) = e^x/(1 + e^(2x)).' from version_ins
union all select gen_random_uuid(), id, 'B', 'e^x/√(1 − e^(2x))', false, 'This uses the derivative of sin⁻¹(e^x), not tan⁻¹(e^x). The derivative of tan⁻¹ u is u′/(1 + u²), with no radical.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e^x/(1 + e^x)', false, 'This uses 1 + u instead of 1 + u². The denominator is 1 + (e^x)² = 1 + e^(2x).' from version_ins
union all select gen_random_uuid(), id, 'D', '1/(1 + e^(2x))', false, 'This keeps the denominator 1 + (e^x)² but omits the chain-rule factor u′ = e^x in the numerator.' from version_ins;
-- apcalcab-mcq-u3n-011-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-011-v2', 'mcq', 'Derivative of inverse sine with a linear inside', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = sin⁻¹(4x), what is f′(x)?', null, md5('apcalcab-mcq-u3n-011-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/√(1 − 4x²)', false, 'This squares only x, not 4x: (4x)² = 16x², so the radicand is 1 − 16x².' from version_ins
union all select gen_random_uuid(), id, 'B', '1/√(1 − 16x²)', false, 'This keeps the denominator √(1 − (4x)²) but omits the chain-rule factor u′ = 4 in the numerator.' from version_ins
union all select gen_random_uuid(), id, 'C', '4/√(1 − 16x²)', true, 'd/dx sin⁻¹ u = u′/√(1 − u²) with u = 4x, u′ = 4, so f′(x) = 4/√(1 − (4x)²) = 4/√(1 − 16x²).' from version_ins
union all select gen_random_uuid(), id, 'D', '4/(1 + 16x²)', false, 'This uses the derivative of tan⁻¹(4x), not sin⁻¹(4x). The derivative of sin⁻¹ u has a radical, √(1 − u²), in the denominator.' from version_ins;
-- apcalcab-mcq-u3n-011-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-011-v3', 'mcq', 'Derivative of inverse cosine', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following is the derivative of y = cos⁻¹(2x)?', null, md5('apcalcab-mcq-u3n-011-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2/√(1 − 4x²)', true, 'd/dx cos⁻¹ u = −u′/√(1 − u²) with u = 2x, u′ = 2, so dy/dx = −2/√(1 − (2x)²) = −2/√(1 − 4x²).' from version_ins
union all select gen_random_uuid(), id, 'B', '−2/(1 + 4x²)', false, 'This uses the tan⁻¹ pattern, 1 + (2x)², with a negative sign. The derivative of cos⁻¹ u has a radical, √(1 − u²), in the denominator.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/√(1 − 4x²)', false, 'This keeps the negative sign and the radical but omits the chain-rule factor u′ = 2 in the numerator.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/√(1 − 4x²)', false, 'This is the derivative of sin⁻¹(2x); it is missing the negative sign. The derivative of cos⁻¹ u is −u′/√(1 − u²).' from version_ins;
-- apcalcab-mcq-u3n-012-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-012-v1', 'mcq', 'Which differentiation rules apply to a quotient', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following correctly identifies the rules needed to differentiate f(x) = e^(x²)/(x + 3)?', null, md5('apcalcab-mcq-u3n-012-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Quotient Rule only, since e^(x²) is its own derivative', false, 'The derivative of e^(x²) is 2x e^(x²), not e^(x²), because the exponent x² is a composite inner function. The quotient rule alone leaves out the factor 2x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Chain Rule only, with x + 3 as the inner function', false, 'f is a ratio of two functions, not a function evaluated at x + 3, so the chain rule alone cannot differentiate it. The division also needs the quotient rule (or a product rule on a rewritten form), together with the chain rule for e^(x²).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Product Rule only, writing e^(x²)(x + 3)⁻¹ as a product', false, 'Even after rewriting as a product, the factor e^(x²) is a composite function whose derivative is 2x e^(x²), which needs the chain rule. The product rule alone is not enough.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Quotient Rule, with the Chain Rule for e^(x²)', true, 'f is a quotient of e^(x²) and x + 3. The numerator e^(x²) is a composite function, so its derivative uses the chain rule: 2x e^(x²). Thus f′(x) = (2x e^(x²)(x + 3) − e^(x²))/(x + 3)².' from version_ins;
commit;
