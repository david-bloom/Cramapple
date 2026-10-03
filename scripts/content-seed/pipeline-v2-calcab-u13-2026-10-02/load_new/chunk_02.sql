begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u2n-013','apcalcab-mcq-u2n-014','apcalcab-mcq-u2n-015','apcalcab-mcq-u3n-001','apcalcab-mcq-u3n-002','apcalcab-mcq-u3n-003','apcalcab-mcq-u3n-004','apcalcab-mcq-u3n-005','apcalcab-mcq-u3n-006','apcalcab-mcq-u3n-008','apcalcab-mcq-u3n-009'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u2n-013
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-013', 'mcq', 'Quotient rule at a point', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = (2x + 1)/(x − 3), what is f′(4)?', null, md5('apcalcab-mcq-u2n-013'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '11', false, 'This adds the terms in the numerator, 2(x − 3) + (2x + 1) = 4x − 5 = 11 at x = 4, using a product-rule sign. The quotient rule subtracts, giving −7.' from version_ins
union all select gen_random_uuid(), id, 'B', '−7', true, 'f′(x) = [2(x − 3) − (2x + 1)(1)]/(x − 3)² = −7/(x − 3)². At x = 4, f′(4) = −7/1 = −7.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This divides the derivatives, 2/1 = 2, as if (u/v)′ = u′/v′. The quotient rule gives [u′v − uv′]/v² = −7.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', false, 'This reverses the numerator, (2x + 1) − 2(x − 3) = 7, instead of (low)(d high) − (high)(d low) = 2(x − 3) − (2x + 1) = −7. At x = 4 the correct value is −7.' from version_ins;
-- apcalcab-mcq-u2n-014
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-014', 'mcq', 'Horizontal tangents of a rational function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which values of x does the graph of y = x/(x² + 4) have a horizontal tangent line?', null, md5('apcalcab-mcq-u2n-014'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There are no such values of x.', false, 'This results from adding the numerator terms, (x² + 4) + 2x² = 3x² + 4, which is never 0. The quotient rule subtracts, giving 4 − x² = 0 at x = ±2, so such points exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = −2 and x = 2', true, 'y′ = [(x² + 4)(1) − x(2x)]/(x² + 4)² = (4 − x²)/(x² + 4)². Setting the numerator 4 − x² = 0 gives x = ±2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0 only', false, 'x = 0 is where y = 0 (the numerator of y), not where y′ = 0. At x = 0, y′ = 4/16 = 1/4, so the tangent is not horizontal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 2 only', false, '4 − x² = 0 has two solutions, x = 2 and x = −2; the negative root was dropped. Both give y′ = 0.' from version_ins;
-- apcalcab-mcq-u2n-015
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-015', 'mcq', 'Derivatives of sec x and cot x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = sec x + cot x, what is f′(π/4)?', null, md5('apcalcab-mcq-u2n-015'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This uses (sec x)′ = sec² x, giving 2 − 2 = 0. The derivative of sec x is sec x tan x, which equals √2 at π/4, so f′(π/4) = √2 − 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '√2 + 2', false, 'This uses (cot x)′ = +csc² x. The correct derivative is −csc² x, so f′(π/4) = √2 − 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '√2 − 2', true, 'f′(x) = sec x tan x − csc² x. At π/4: sec = √2, tan = 1, csc² = 2, so f′(π/4) = √2·1 − 2 = √2 − 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−√2 − 2', false, 'This uses (sec x)′ = −sec x tan x, a sign pattern borrowed from cos and csc. The derivative of sec x is +sec x tan x, so f′(π/4) = √2 − 2.' from version_ins;
-- apcalcab-mcq-u3n-001
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-001', 'mcq', 'Chain rule on a power of a quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = (3x² − 5)⁴, what is f′(x)?', null, md5('apcalcab-mcq-u3n-001'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24x(3x² − 5)⁴', false, 'The coefficient 24x is correct, but the exponent was not lowered: the power rule turns the exponent 4 into 3, so the factor is (3x² − 5)³.' from version_ins
union all select gen_random_uuid(), id, 'B', '864x³', false, 'This replaces the inside by its derivative, 4(6x)³ = 4 · 216x³ = 864x³. The inner function 3x² − 5 must stay inside the power, and 6x appears only as a multiplier.' from version_ins
union all select gen_random_uuid(), id, 'C', '24x(3x² − 5)³', true, 'Outer function u⁴ has derivative 4u³ and inner function 3x² − 5 has derivative 6x, so f′(x) = 4(3x² − 5)³ · 6x = 24x(3x² − 5)³.' from version_ins
union all select gen_random_uuid(), id, 'D', '4(3x² − 5)³', false, 'This applies the power rule to the outer function but omits the inner derivative 6x; the chain rule requires the factor 6x, giving 24x(3x² − 5)³.' from version_ins;
-- apcalcab-mcq-u3n-002
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-002', 'mcq', 'Tangent slope of an exponential composite', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The curve y = e^(3x² − x) passes through the point (1, e²). What is the slope of the tangent line to the curve at x = 1?', null, md5('apcalcab-mcq-u3n-002'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5e⁵', false, 'This writes e^(u′) = e^(6x − 1) = e⁵ and also multiplies by 5. The exponent must stay u = 3x² − x = 2, and u′ = 5 appears only as a multiplier, giving 5e².' from version_ins
union all select gen_random_uuid(), id, 'B', '2e²', false, 'This uses (3x² − x) · e^(3x² − x) = 2 · e² at x = 1, treating e^u like a product u · e^u. The derivative of e^u is e^u · u′, where u′ = 6x − 1 = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e²', false, 'This is e^(3x² − x) evaluated at x = 1 with no inner derivative; the chain rule multiplies by 6x − 1 = 5, so the slope is 5e², not e².' from version_ins
union all select gen_random_uuid(), id, 'D', '5e²', true, 'dy/dx = e^(3x² − x) · (6x − 1). At x = 1 the exponent is 2 and 6x − 1 = 5, so the slope is 5e².' from version_ins;
-- apcalcab-mcq-u3n-003
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-003', 'mcq', 'Chain rule from a table of values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives values of the differentiable functions f and g.

x | f(x) | f′(x) | g(x) | g′(x)
2 | 6 | 4 | 3 | −2
3 | 1 | 5 | 7 | 0

Let h(x) = f(g(x)). What is h′(2)?', null, md5('apcalcab-mcq-u3n-003'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−8', false, 'This uses f′(2) · g′(2) = 4 · (−2) = −8, evaluating f′ at x = 2. The outer derivative must be evaluated at the inner value g(2) = 3, so f′(3) = 5 is needed.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This is f′(g(2)) = f′(3) = 5 only; it omits the factor g′(2) = −2 required by the chain rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '−10', true, 'h′(x) = f′(g(x)) · g′(x). Since g(2) = 3, h′(2) = f′(3) · g′(2) = 5 · (−2) = −10.' from version_ins
union all select gen_random_uuid(), id, 'D', '15', false, 'This multiplies f′(3) = 5 by g(2) = 3, using the value of g instead of its derivative. The chain rule needs g′(2) = −2, giving −10.' from version_ins;
-- apcalcab-mcq-u3n-004
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-004', 'mcq', 'Three-layer composite derivative', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = √(ln(x² + 1)) for x > 0, what is f′(x)?', null, md5('apcalcab-mcq-u3n-004'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x/((x² + 1)√(ln(x² + 1)))', true, 'Differentiate layer by layer: (1/(2√(ln(x² + 1)))) · (1/(x² + 1)) · 2x = 2x/(2(x² + 1)√(ln(x² + 1))) = x/((x² + 1)√(ln(x² + 1))).' from version_ins
union all select gen_random_uuid(), id, 'B', '1/(2(x² + 1)√(ln(x² + 1)))', false, 'This applies the square-root and logarithm layers but omits the innermost derivative 2x of x² + 1. Including it gives x/((x² + 1)√(ln(x² + 1))).' from version_ins
union all select gen_random_uuid(), id, 'C', '2x/((x² + 1)√(ln(x² + 1)))', false, 'This drops the factor 1/2 that comes from differentiating the square root: d/du √u = 1/(2√u). With it, the 2x in the numerator cancels to x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x/√(ln(x² + 1))', false, 'This keeps the factor 2x from the inner function and the 1/2 from the square root but omits the derivative of ln u, which is u′/u = 2x/(x² + 1). The factor 1/(x² + 1) is missing.' from version_ins;
-- apcalcab-mcq-u3n-005
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-005', 'mcq', 'Implicit slope with a product term', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The curve x²y = 12 passes through the point (2, 3). What is dy/dx at (2, 3)?', null, md5('apcalcab-mcq-u3n-005'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12', false, 'This stops at x² · dy/dx = −12 (the value of −2xy at the point) without dividing by x² = 4. Dividing gives dy/dx = −3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3', true, 'Differentiate both sides with the product rule: 2xy + x² · dy/dx = 0. At (2, 3): 12 + 4 · dy/dx = 0, so dy/dx = −3.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This differentiates x²y as 2x + x² · dy/dx, leaving out the factor y in the term 2xy. Then 4 + 4 · dy/dx = 0 gives −1. The product rule gives 2xy = 12 at the point, so dy/dx = −3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'This moves 2xy across with the wrong sign (x² · dy/dx = 2xy), giving 12/4 = 3. The equation 2xy + x² · dy/dx = 0 gives x² · dy/dx = −2xy = −12, so dy/dx = −3.' from version_ins;
-- apcalcab-mcq-u3n-006
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-006', 'mcq', 'Implicit slope with a logarithm of y', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The curve xy + ln y = 2 passes through the point (2, 1). What is dy/dx at (2, 1)?', null, md5('apcalcab-mcq-u3n-006'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/3', false, 'This writes the derivative of the constant 2 as 2 instead of 0: 1 + 3 · dy/dx = 2, giving 1/3. Since d/dx(2) = 0, the equation is 1 + 3 · dy/dx = 0 and dy/dx = −1/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/3', true, 'Differentiate both sides: y + x · dy/dx + (1/y) · dy/dx = 0. At (2, 1): 1 + 2 · dy/dx + dy/dx = 0, so 3 · dy/dx = −1 and dy/dx = −1/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'This differentiates xy as x · dy/dx, dropping the term y from the product rule. Then 2 · dy/dx + dy/dx = 0 gives 0. The product rule term y = 1 contributes, giving dy/dx = −1/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', false, 'This differentiates ln y as 1/y without the factor dy/dx. Then 1 + 2 · dy/dx + 1 = 0 gives dy/dx = −1. The chain rule requires (1/y) · dy/dx, which gives −1/3.' from version_ins;
-- apcalcab-mcq-u3n-008
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-008', 'mcq', 'Inverse derivative from a table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is differentiable and one-to-one. Selected values are given in the table.

x | f(x) | f′(x)
1 | 2 | 3
2 | 5 | 4
3 | 8 | 6
5 | 9 | 7

What is (f⁻¹)′(5)?', null, md5('apcalcab-mcq-u3n-008'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/5', false, 'This takes the reciprocal of 5 itself. The reciprocal must be of the slope f′(2) = 4, not of the input value 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This is f′(2), the derivative of f rather than of f⁻¹. The derivative of the inverse is the reciprocal, 1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/4', true, 'f(2) = 5, so f⁻¹(5) = 2, and (f⁻¹)′(5) = 1/f′(f⁻¹(5)) = 1/f′(2) = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/7', false, 'This uses 1/f′(5) = 1/7, plugging 5 into f′. The formula requires f′ at f⁻¹(5) = 2, so the value is 1/f′(2) = 1/4.' from version_ins;
-- apcalcab-mcq-u3n-009
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-009', 'mcq', 'Inverse derivative for a cubic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³ + 2x + 1, which is one-to-one. What is (f⁻¹)′(4)?', null, md5('apcalcab-mcq-u3n-009'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/50', false, 'This uses 1/f′(4) = 1/(3 · 16 + 2) = 1/50, evaluating f′ at 4. The formula needs f′ at f⁻¹(4) = 1, where f′(1) = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/5', true, 'f(1) = 1 + 2 + 1 = 4, so f⁻¹(4) = 1. Since f′(x) = 3x² + 2, f′(1) = 5, and (f⁻¹)′(4) = 1/f′(1) = 1/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This is f′(1), the slope of f at the matching point. The slope of f⁻¹ is its reciprocal, 1/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/4', false, 'This takes the reciprocal of the value f(1) = 4. The reciprocal must be of the derivative f′(1) = 5, not of the function value.' from version_ins;
commit;
