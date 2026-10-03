begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u2n-015-v1','apcalcab-mcq-u2n-015-v2','apcalcab-mcq-u3n-001-v1','apcalcab-mcq-u3n-001-v2','apcalcab-mcq-u3n-001-v3','apcalcab-mcq-u3n-002-v1','apcalcab-mcq-u3n-002-v2','apcalcab-mcq-u3n-002-v3','apcalcab-mcq-u3n-003-v1','apcalcab-mcq-u3n-003-v2','apcalcab-mcq-u3n-003-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u2n-015-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-015-v1', 'mcq', 'Derivatives of csc x and tan x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = csc x + tan x, what is f′(π/6)?', null, md5('apcalcab-mcq-u2n-015-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4/3 − 2√3', false, 'This uses (tan x)′ = −sec² x, a sign borrowed from cos. The derivative of tan x is +sec² x = 4/3, so f′(π/6) = 4/3 − 2√3.' from version_ins
union all select gen_random_uuid(), id, 'B', '4/3 + 2√3', false, 'This uses (csc x)′ = +csc x cot x. The correct derivative is −csc x cot x = −2√3, so f′(π/6) = 4/3 − 2√3.' from version_ins
union all select gen_random_uuid(), id, 'C', '4/3 − 2√3', true, 'f′(x) = −csc x cot x + sec² x. At π/6: csc = 2, cot = √3, sec² = 4/3, so f′(π/6) = −2√3 + 4/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '−8/3', false, 'This uses (csc x)′ = −csc² x = −4 (confusing it with cot), giving −4 + 4/3 = −8/3. The derivative of csc x is −csc x cot x = −2√3.' from version_ins;
-- apcalcab-mcq-u2n-015-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-015-v2', 'mcq', 'Derivatives of sec x and cot x at pi/3', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = sec x − cot x. Find g′(π/3).', null, md5('apcalcab-mcq-u2n-015-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2√3 + 4/3', true, 'g′(x) = sec x tan x + csc² x. At π/3: sec = 2, tan = √3, csc² = 4/3, so g′(π/3) = 2√3 + 4/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '16/3', false, 'This uses (sec x)′ = sec² x = 4, giving 4 + 4/3 = 16/3. The derivative of sec x is sec x tan x = 2√3.' from version_ins
union all select gen_random_uuid(), id, 'C', '2√3 + 2/3', false, 'This uses (cot x)′ = −csc x cot x = −2/3, so −cot x contributes +2/3. The derivative of cot x is −csc² x, which makes −cot x contribute +4/3, so g′(π/3) = 2√3 + 4/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '2√3 − 4/3', false, 'This uses (cot x)′ = +csc² x, so the subtracted term gives −4/3. Since (cot x)′ = −csc² x, the term −cot x contributes +csc² x = +4/3, so g′(π/3) = 2√3 + 4/3.' from version_ins;
-- apcalcab-mcq-u3n-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-001-v1', 'mcq', 'Chain rule on a power of a cubic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x³ − 2x)⁵. Which expression gives f′(x)?', null, md5('apcalcab-mcq-u3n-001-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5(3x² − 2)(x³ − 2x)⁴', true, 'The outer power u⁵ has derivative 5u⁴ and the inner function x³ − 2x has derivative 3x² − 2, so f′(x) = 5(x³ − 2x)⁴(3x² − 2).' from version_ins
union all select gen_random_uuid(), id, 'B', '5(3x² − 2)⁴', false, 'This replaces the inside x³ − 2x by its derivative 3x² − 2 and raises that to the fourth power. The inner function must stay inside the power, with 3x² − 2 appearing only as a multiplier.' from version_ins
union all select gen_random_uuid(), id, 'C', '5(x³ − 2x)⁴', false, 'This applies the power rule to the outer function but omits the inner derivative 3x² − 2. The chain rule requires that factor.' from version_ins
union all select gen_random_uuid(), id, 'D', '5(3x² − 2)(x³ − 2x)⁵', false, 'The factor 5(3x² − 2) is correct, but the exponent was not lowered: the power rule turns 5 into 4, so the factor is (x³ − 2x)⁴.' from version_ins;
-- apcalcab-mcq-u3n-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-001-v2', 'mcq', 'Chain rule on a square root', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = √(6x − x²) on the interval 0 < x < 6. What is f′(x)?', null, md5('apcalcab-mcq-u3n-001-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(6 − 2x)/√(6x − x²)', false, 'This drops the factor 1/2 from the power rule: d/du √u = 1/(2√u). With it, (6 − 2x)/(2√(6x − x²)) simplifies to (3 − x)/√(6x − x²).' from version_ins
union all select gen_random_uuid(), id, 'B', '1/(2√(6x − x²))', false, 'This differentiates the square root but omits the inner derivative 6 − 2x. The chain rule multiplies by 6 − 2x, giving (3 − x)/√(6x − x²).' from version_ins
union all select gen_random_uuid(), id, 'C', '(3 − x)√(6x − x²)', false, 'This keeps the exponent 1/2 instead of lowering it to −1/2: (1/2)(6 − 2x)(6x − x²)^(1/2) = (3 − x)√(6x − x²). The power rule gives (6x − x²)^(−1/2), which belongs in the denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3 − x)/√(6x − x²)', true, 'Write f(x) = (6x − x²)^(1/2). Then f′(x) = (1/2)(6x − x²)^(−1/2)(6 − 2x) = (6 − 2x)/(2√(6x − x²)) = (3 − x)/√(6x − x²).' from version_ins;
-- apcalcab-mcq-u3n-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-001-v3', 'mcq', 'Chain rule on a reciprocal power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = 1/(4x² + 3)², what is f′(x)?', null, md5('apcalcab-mcq-u3n-001-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2/(4x² + 3)³', false, 'This applies the power rule to the outer function but omits the inner derivative 8x. The chain rule requires that factor, giving −16x/(4x² + 3)³.' from version_ins
union all select gen_random_uuid(), id, 'B', '−16x/(4x² + 3)²', false, 'The coefficient −16x is correct, but the exponent −2 was not lowered to −3. The denominator must be (4x² + 3)³.' from version_ins
union all select gen_random_uuid(), id, 'C', '16x/(4x² + 3)³', false, 'The exponent is correct, but the negative sign from the outer exponent −2 was lost: (−2)(8x) = −16x, not 16x.' from version_ins
union all select gen_random_uuid(), id, 'D', '−16x/(4x² + 3)³', true, 'Write f(x) = (4x² + 3)^(−2). Then f′(x) = −2(4x² + 3)^(−3)(8x) = −16x/(4x² + 3)³.' from version_ins;
-- apcalcab-mcq-u3n-002-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-002-v1', 'mcq', 'Tangent slope of e^(x² − 4x)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of y = e^(x² − 4x) contains the point (3, e^(−3)). Find the slope of the tangent line to the graph at x = 3.', null, md5('apcalcab-mcq-u3n-002-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e^(−3)', false, 'This is e^(x² − 4x) at x = 3 with no inner derivative. The chain rule multiplies by 2x − 4 = 2, so the slope is 2e^(−3).' from version_ins
union all select gen_random_uuid(), id, 'B', '2e²', false, 'This writes e^(u′) = e^(2x − 4) = e² and multiplies by 2. The exponent must stay u = x² − 4x = −3, and u′ = 2 appears only as a multiplier, giving 2e^(−3).' from version_ins
union all select gen_random_uuid(), id, 'C', '2e^(−3)', true, 'dy/dx = e^(x² − 4x)·(2x − 4). At x = 3 the exponent is −3 and 2x − 4 = 2, so the slope is 2e^(−3).' from version_ins
union all select gen_random_uuid(), id, 'D', '−3e^(−3)', false, 'This multiplies by the exponent value u = −3 instead of u′ = 2, treating e^u like u·e^u. The derivative of e^u is e^u·u′, so the slope is 2e^(−3).' from version_ins;
-- apcalcab-mcq-u3n-002-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-002-v2', 'mcq', 'Tangent slope of a logarithm of a quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The curve y = ln(x² + 3x) passes through the point (2, ln 10). What is the slope of the tangent line to the curve at x = 2?', null, md5('apcalcab-mcq-u3n-002-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/10', false, 'This is 1/(x² + 3x) = 1/10, the derivative of ln u as 1/u with no inner derivative. The chain rule multiplies by u′ = 2x + 3 = 7, giving 7/10.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This uses only the inner derivative u′ = 2x + 3 = 7 and omits the factor 1/u = 1/10 from differentiating ln u. The slope is u′/u = 7/10.' from version_ins
union all select gen_random_uuid(), id, 'C', '70', false, 'This multiplies u′ = 7 by u = 10 instead of dividing, as if (ln u)′ = u′·u. The derivative of ln u is u′/u, so the slope is 7/10.' from version_ins
union all select gen_random_uuid(), id, 'D', '7/10', true, 'dy/dx = (2x + 3)/(x² + 3x). At x = 2: (4 + 3)/(4 + 6) = 7/10.' from version_ins;
-- apcalcab-mcq-u3n-002-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-002-v3', 'mcq', 'Tangent slope of cos(πx²)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of y = cos(πx²) passes through the point (1/2, √2/2). What is the slope of the tangent line at x = 1/2?', null, md5('apcalcab-mcq-u3n-002-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This replaces the inside πx² by its derivative 2πx, giving −sin(2πx) = −sin π = 0. The inner function must stay inside sine, with 2πx appearing only as a multiplier.' from version_ins
union all select gen_random_uuid(), id, 'B', '−√2/2', false, 'This is −sin(πx²) = −sin(π/4) at x = 1/2 with no inner derivative. The chain rule multiplies by 2πx = π, giving −π√2/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−π√2/2', true, 'dy/dx = −sin(πx²)·(2πx). At x = 1/2: −sin(π/4)·π = −(√2/2)π = −π√2/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π√2/2', false, 'This uses (cos u)′ = +sin u, dropping the negative sign. The derivative of cos u is −sin u·u′, so the slope is −π√2/2.' from version_ins;
-- apcalcab-mcq-u3n-003-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-003-v1', 'mcq', 'Chain rule from a table, f of g', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Selected values of the differentiable functions f and g are listed below.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 4 | −3 | 2 | 6
2 | 0 | 7 | −1 | 5
4 | 3 | 2 | 4 | −2

Define p by composing f with g, so that p(x) = f(g(x)). Find the value of p′(1).', null, md5('apcalcab-mcq-u3n-003-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '42', true, 'p′(x) = f′(g(x))·g′(x). Since g(1) = 2, p′(1) = f′(2)·g′(1) = 7·6 = 42.' from version_ins
union all select gen_random_uuid(), id, 'B', '14', false, 'This multiplies f′(2) = 7 by g(1) = 2, using the value of g instead of its derivative. The chain rule needs g′(1) = 6, giving 42.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'This is f′(g(1)) = f′(2) = 7 only; it omits the factor g′(1) = 6 required by the chain rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '−18', false, 'This uses f′(1)·g′(1) = (−3)(6) = −18, evaluating f′ at x = 1. The outer derivative must be evaluated at g(1) = 2, so f′(2) = 7 is needed.' from version_ins;
-- apcalcab-mcq-u3n-003-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-003-v2', 'mcq', 'Chain rule from function values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let F and G be differentiable functions with G(2) = 5, G′(2) = 3, F(2) = −1, F′(2) = 4, F(5) = 2, and F′(5) = −6. If H(x) = F(G(x)), what is H′(2)?', null, md5('apcalcab-mcq-u3n-003-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', false, 'This is F′(G(2)) = F′(5) = −6 only; it omits the factor G′(2) = 3 required by the chain rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', false, 'This uses F′(2)·G′(2) = 4·3 = 12, evaluating F′ at x = 2. The outer derivative must be evaluated at G(2) = 5, so F′(5) = −6 is needed.' from version_ins
union all select gen_random_uuid(), id, 'C', '−30', false, 'This multiplies F′(5) = −6 by G(2) = 5, using the value of G instead of its derivative. The chain rule needs G′(2) = 3, giving −18.' from version_ins
union all select gen_random_uuid(), id, 'D', '−18', true, 'H′(x) = F′(G(x))·G′(x). Since G(2) = 5, H′(2) = F′(5)·G′(2) = (−6)(3) = −18.' from version_ins;
-- apcalcab-mcq-u3n-003-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-003-v3', 'mcq', 'Chain rule from a table, g of f', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the following values.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 3 | −2 | 4 | 5
3 | 1 | 6 | −2 | 3

If q(x) = g(f(x)), what is q′(1)?', null, md5('apcalcab-mcq-u3n-003-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−10', false, 'This uses g′(1)·f′(1) = 5·(−2) = −10, evaluating g′ at x = 1. The outer derivative must be evaluated at f(1) = 3, so g′(3) = 3 is needed.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'This is g′(f(1)) = g′(3) = 3 only; it omits the factor f′(1) = −2 required by the chain rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '9', false, 'This multiplies g′(3) = 3 by f(1) = 3, using the value of f instead of its derivative. The chain rule needs f′(1) = −2, giving −6.' from version_ins
union all select gen_random_uuid(), id, 'D', '−6', true, 'q′(x) = g′(f(x))·f′(x). Since f(1) = 3, q′(1) = g′(3)·f′(1) = 3·(−2) = −6.' from version_ins;
commit;
