begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u3n-004-v1','apcalcab-mcq-u3n-004-v2','apcalcab-mcq-u3n-004-v3','apcalcab-mcq-u3n-005-v1','apcalcab-mcq-u3n-005-v2','apcalcab-mcq-u3n-005-v3','apcalcab-mcq-u3n-006-v1','apcalcab-mcq-u3n-006-v2','apcalcab-mcq-u3n-006-v3','apcalcab-mcq-u3n-008-v1','apcalcab-mcq-u3n-008-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u3n-004-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-004-v1', 'mcq', 'Three-layer exponential-radical composite', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = e^(√(x² + 1)), what is f′(x)?', null, md5('apcalcab-mcq-u3n-004-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x e^(√(x² + 1))/√(x² + 1)', true, 'Differentiate layer by layer: e^(√(x² + 1))·(1/(2√(x² + 1)))·2x = 2x e^(√(x² + 1))/(2√(x² + 1)) = x e^(√(x² + 1))/√(x² + 1).' from version_ins
union all select gen_random_uuid(), id, 'B', 'x/√(x² + 1)', false, 'This differentiates only the exponent √(x² + 1) and omits the factor e^(√(x² + 1)), which is the derivative of the outer exponential layer.' from version_ins
union all select gen_random_uuid(), id, 'C', '2x e^(√(x² + 1))/√(x² + 1)', false, 'This drops the factor 1/2 from differentiating the square root: d/du √u = 1/(2√u). With it, the 2x in the numerator cancels to x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^(√(x² + 1))/(2√(x² + 1))', false, 'This applies the exponential and square-root layers but omits the innermost derivative 2x of x² + 1. Including it gives x e^(√(x² + 1))/√(x² + 1).' from version_ins;
-- apcalcab-mcq-u3n-004-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-004-v2', 'mcq', 'Logarithm of a sine of a quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = ln(sin(x²)) for 0 < x < √π. What is f′(x)?', null, md5('apcalcab-mcq-u3n-004-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x/sin(x²)', false, 'This applies the logarithm layer and the innermost derivative 2x but omits the derivative of the sine layer, cos(x²).' from version_ins
union all select gen_random_uuid(), id, 'B', '2x cos(x²)/sin(x²)', true, 'Differentiate layer by layer: (1/sin(x²))·cos(x²)·2x = 2x cos(x²)/sin(x²).' from version_ins
union all select gen_random_uuid(), id, 'C', 'cos(x²)/sin(x²)', false, 'This applies the logarithm and sine layers but omits the innermost derivative 2x of x². The chain rule requires that factor.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2x cos(x²)/sin(x²)', false, 'This uses (sin u)′ = −cos u, a sign borrowed from cosine. The derivative of sin u is +cos u, so the result is +2x cos(x²)/sin(x²).' from version_ins;
-- apcalcab-mcq-u3n-004-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-004-v3', 'mcq', 'Cube of a sine of a multiple', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (sin(2x))³. Which expression gives f′(x)?', null, md5('apcalcab-mcq-u3n-004-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6(sin(2x))²cos(2x)', true, 'Differentiate layer by layer: 3(sin(2x))²·cos(2x)·2 = 6(sin(2x))²cos(2x).' from version_ins
union all select gen_random_uuid(), id, 'B', '3(sin(2x))²cos(2x)', false, 'This applies the power and sine layers but omits the innermost derivative 2 of 2x. Including it doubles the result to 6(sin(2x))²cos(2x).' from version_ins
union all select gen_random_uuid(), id, 'C', '6(sin(2x))²', false, 'This applies the power layer and the innermost factor 2 but omits the derivative of the sine layer, cos(2x).' from version_ins
union all select gen_random_uuid(), id, 'D', '−6(sin(2x))²cos(2x)', false, 'This uses (sin u)′ = −cos u, a sign borrowed from cosine. The derivative of sin u is +cos u, so the result is +6(sin(2x))²cos(2x).' from version_ins;
-- apcalcab-mcq-u3n-005-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-005-v1', 'mcq', 'Implicit slope of xy² = 18', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A curve is defined implicitly by xy² = 18, and the point (2, 3) lies on the curve. Find the slope of the tangent line at that point.', null, md5('apcalcab-mcq-u3n-005-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3/4', true, 'Differentiate both sides with the product rule: y² + 2xy·dy/dx = 0. At (2, 3): 9 + 12·dy/dx = 0, so dy/dx = −3/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/4', false, 'This has the wrong sign: it moves y² across as 12·dy/dx = +9, giving 3/4. The equation y² + 2xy·dy/dx = 0 gives 12·dy/dx = −9, so dy/dx = −3/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3/2', false, 'This differentiates xy² as y² + 2y·dy/dx, dropping the factor x from the term 2xy·dy/dx. Then 9 + 6·dy/dx = 0 gives −3/2. The correct equation is 9 + 12·dy/dx = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '−9', false, 'This stops at 12·dy/dx = −9 and does not divide by 12. Dividing gives dy/dx = −9/12 = −3/4.' from version_ins;
-- apcalcab-mcq-u3n-005-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-005-v2', 'mcq', 'Implicit slope of x² + xy + y² = 7', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The relation x² + xy + y² = 7 holds at the point (2, 1). What is dy/dx at (2, 1)?', null, md5('apcalcab-mcq-u3n-005-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/4', false, 'This has the wrong sign: from 5 + 4·dy/dx = 0 it takes dy/dx = +5/4. Moving 5 to the other side gives 4·dy/dx = −5, so dy/dx = −5/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5/4', true, 'Differentiate: 2x + y + x·dy/dx + 2y·dy/dx = 0. At (2, 1): 4 + 1 + 2·dy/dx + 2·dy/dx = 0, so 5 + 4·dy/dx = 0 and dy/dx = −5/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This differentiates xy as x·dy/dx, leaving out the term y from the product rule. Then 4 + 2·dy/dx + 2·dy/dx = 0 gives −1. The product rule gives y + x·dy/dx, so the equation is 5 + 4·dy/dx = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '−7/2', false, 'This differentiates y² as 2y without the factor dy/dx. Then 4 + 1 + 2·dy/dx + 2 = 0 gives dy/dx = −7/2. The chain rule gives 2y·dy/dx, so the equation is 5 + 4·dy/dx = 0.' from version_ins;
-- apcalcab-mcq-u3n-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-005-v3', 'mcq', 'Implicit slope of y·eˣ = 5e', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Point P = (1, 5) lies on the graph of the relation y·eˣ = 5e. Determine the slope of the tangent line to the graph at P.', null, md5('apcalcab-mcq-u3n-005-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−5e', false, 'This stops at e·dy/dx = −5e without dividing by e. Dividing by e gives dy/dx = −5.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5', true, 'Differentiate with the product rule: (dy/dx)eˣ + y·eˣ = 0. At (1, 5): e·dy/dx + 5e = 0, so dy/dx = −5.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'This omits the term y·eˣ from the product rule, leaving (dy/dx)eˣ = 0 and dy/dx = 0. The product rule gives e·dy/dx + 5e = 0, so dy/dx = −5.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'This has the wrong sign: from e·dy/dx + 5e = 0 it takes dy/dx = +5. Moving 5e across gives e·dy/dx = −5e, so dy/dx = −5.' from version_ins;
-- apcalcab-mcq-u3n-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-006-v1', 'mcq', 'Implicit slope with an exponential in y', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A curve is defined implicitly by e^y + xy = e + 2, and the point (2, 1) lies on it. Find the slope of the tangent line to the curve at that point.', null, md5('apcalcab-mcq-u3n-006-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−(e + 1)/2', false, 'This differentiates e^y as e^y without the chain-rule factor dy/dx. Then e + 1 + 2 · dy/dx = 0 gives dy/dx = −(e + 1)/2. The correct derivative of e^y is e^y · dy/dx, which gives −1/(e + 2).' from version_ins
union all select gen_random_uuid(), id, 'B', '(e + 1)/(e + 2)', false, 'This differentiates the constant e + 2 as e + 2 instead of 0. Then e · dy/dx + 1 + 2 · dy/dx = e + 2 gives (e + 2) · dy/dx = e + 1. Since d/dx(e + 2) = 0, the equation is (e + 2) · dy/dx + 1 = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/(e + 2)', true, 'Differentiate both sides: e^y · dy/dx + y + x · dy/dx = 0. At (2, 1): e · dy/dx + 1 + 2 · dy/dx = 0, so (e + 2) · dy/dx = −1 and dy/dx = −1/(e + 2).' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This differentiates xy as x · dy/dx, dropping the product-rule term y. Then e · dy/dx + 2 · dy/dx = 0 gives dy/dx = 0. The term y = 1 contributes, giving −1/(e + 2).' from version_ins;
-- apcalcab-mcq-u3n-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-006-v2', 'mcq', 'Implicit slope of a trigonometric curve', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of sin(xy) + y = π/2 contains the point (2, π/2). Find dy/dx at this point.', null, md5('apcalcab-mcq-u3n-006-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/2', false, 'This differentiates xy as y alone, dropping x · dy/dx from the product rule. Then cos π · (π/2) + dy/dx = 0 gives −π/2 + dy/dx = 0, so dy/dx = π/2. The inner derivative of xy is y + x · dy/dx, which gives −π/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−π/2', true, 'Differentiate both sides: cos(xy) · (y + x · dy/dx) + dy/dx = 0. At (2, π/2), xy = π and cos π = −1, so −(π/2 + 2 · dy/dx) + dy/dx = 0, which gives −π/2 − dy/dx = 0 and dy/dx = −π/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−π/6', false, 'This evaluates cos π as 1 instead of −1. Then (π/2 + 2 · dy/dx) + dy/dx = 0 gives 3 · dy/dx = −π/2, so dy/dx = −π/6. Since cos π = −1, the correct value is −π/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This differentiates sin(xy) as cos(xy) with no inner-derivative factor. Then cos π + dy/dx = 0 gives −1 + dy/dx = 0, so dy/dx = 1. The chain rule requires multiplying by (y + x · dy/dx), which gives −π/2.' from version_ins;
-- apcalcab-mcq-u3n-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-006-v3', 'mcq', 'Implicit slope with ln x and y squared', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the curve y ln x + y² = 2, which passes through the point (e, 1). What is the value of dy/dx at (e, 1)?', null, md5('apcalcab-mcq-u3n-006-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/(3e)', true, 'Differentiate both sides: (dy/dx) ln x + y/x + 2y · dy/dx = 0. At (e, 1), ln e = 1: dy/dx + 1/e + 2 · dy/dx = 0, so 3 · dy/dx = −1/e and dy/dx = −1/(3e).' from version_ins
union all select gen_random_uuid(), id, 'B', '(2e − 1)/(3e)', false, 'This differentiates the constant 2 on the right side as 2 instead of 0. Then 3 · dy/dx + 1/e = 2 gives dy/dx = (2 − 1/e)/3 = (2e − 1)/(3e). Since d/dx(2) = 0, the equation is 3 · dy/dx + 1/e = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '−(2e + 1)/e', false, 'This differentiates y² as 2y without the factor dy/dx. At (e, 1) that gives dy/dx + 1/e + 2 = 0, so dy/dx = −2 − 1/e = −(2e + 1)/e. The chain rule gives 2y · dy/dx, which leads to −1/(3e).' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This differentiates y ln x as (dy/dx) ln x, dropping the product-rule term y/x. Then dy/dx + 2 · dy/dx = 0 gives dy/dx = 0. The term y/x = 1/e contributes, giving −1/(3e).' from version_ins;
-- apcalcab-mcq-u3n-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-008-v1', 'mcq', 'Inverse slope from a table of values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Some values of a differentiable, invertible function f and of its derivative f′ are tabulated below.

x | f(x) | f′(x)
1 | 3 | 2
2 | 6 | 5
4 | 8 | 3
6 | 13 | 9

Find the slope of the graph of f⁻¹ at the point where the input is 6.', null, md5('apcalcab-mcq-u3n-008-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/5', true, 'f(2) = 6, so f⁻¹(6) = 2, and (f⁻¹)′(6) = 1/f′(f⁻¹(6)) = 1/f′(2) = 1/5.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This is f′(2), the derivative of f rather than of f⁻¹. The derivative of the inverse is the reciprocal, 1/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/9', false, 'This uses 1/f′(6) = 1/9, plugging the input 6 into f′. The formula requires f′ at f⁻¹(6) = 2, where f′(2) = 5, so the value is 1/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'This is f⁻¹(6) = 2, the value of the inverse function itself, not its derivative. The derivative is 1/f′(2) = 1/5.' from version_ins;
-- apcalcab-mcq-u3n-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-008-v2', 'mcq', 'Inverse rate for a filling tank', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The depth of water in a tank is g(t) centimeters at time t minutes, where g is differentiable and strictly increasing. Selected values are given.

t | g(t) | g′(t)
0 | 4 | 1/2
3 | 10 | 2/3
5 | 12 | 3/4
8 | 15 | 5/4

What is (g⁻¹)′(10)?', null, md5('apcalcab-mcq-u3n-008-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/3', false, 'This is g′(3), the derivative of g rather than of g⁻¹. The derivative of the inverse is the reciprocal, 3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'This is g⁻¹(10) = 3, the time at which the depth is 10, not the derivative of g⁻¹. The derivative is 1/g′(3) = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/2', true, 'g(3) = 10, so g⁻¹(10) = 3, and (g⁻¹)′(10) = 1/g′(g⁻¹(10)) = 1/g′(3) = 1/(2/3) = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/10', false, 'This takes the reciprocal of the input value 10. The reciprocal must be of the slope g′(3) = 2/3, so the value is 3/2.' from version_ins;
commit;
