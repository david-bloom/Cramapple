begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u2n-011-v1','apcalcab-mcq-u2n-011-v3','apcalcab-mcq-u2n-012-v1','apcalcab-mcq-u2n-012-v2','apcalcab-mcq-u2n-012-v3','apcalcab-mcq-u2n-013-v1','apcalcab-mcq-u2n-013-v2','apcalcab-mcq-u2n-013-v3','apcalcab-mcq-u2n-014-v1','apcalcab-mcq-u2n-014-v2','apcalcab-mcq-u2n-014-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u2n-011-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-011-v1', 'mcq', 'Product rule with a cubic factor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = (x³ − 4)(2x + 5). Find the value of g′(1).', null, md5('apcalcab-mcq-u2n-011-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '27', false, 'This subtracts the terms, u′v − uv′ = 21 − (−6) = 27, using a quotient-rule-style sign. The product rule adds them: 21 + (−6) = 15.' from version_ins
union all select gen_random_uuid(), id, 'B', '15', true, 'By the product rule, g′(x) = 3x²(2x + 5) + (x³ − 4)(2). At x = 1: 3(7) + (−3)(2) = 21 − 6 = 15.' from version_ins
union all select gen_random_uuid(), id, 'C', '21', false, 'This keeps only u′v = 3·7 = 21 and omits the second term uv′ = (−3)(2) = −6. The product rule needs both terms, so g′(1) = 21 − 6 = 15.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This multiplies the derivatives of the factors, (3x²)(2) = 3·2 = 6 at x = 1. The product rule is u′v + uv′ = 21 + (−6) = 15, not u′v′.' from version_ins;
-- apcalcab-mcq-u2n-011-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-011-v3', 'mcq', 'Product rule with a sine factor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the function h(x) = (x² + 1) sin x. Evaluate h′(π).', null, md5('apcalcab-mcq-u2n-011-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This keeps only u′v = 2π·sin π = 0 and omits uv′ = (π² + 1)cos π = −(π² + 1). The product rule needs both terms, so h′(π) = −π² − 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '−π² − 1', true, 'h′(x) = 2x sin x + (x² + 1) cos x. At x = π: 2π(0) + (π² + 1)(−1) = −π² − 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2π', false, 'This multiplies the derivatives of the factors, (2x)(cos x) = 2π·(−1) = −2π. The product rule is u′v + uv′ = −π² − 1, not u′v′.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π² + 1', false, 'This subtracts the terms, u′v − uv′ = 0 − (π² + 1)(−1) = π² + 1, a quotient-rule-style sign. The product rule adds: 0 + (−(π² + 1)) = −π² − 1.' from version_ins;
-- apcalcab-mcq-u2n-012-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-012-v1', 'mcq', 'Spot the product rule error with a cube', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let k(x) = x³·f(x), where f(2) = −1 and f′(2) = 4. A student writes k′(2) = (3·2²)(4) = 48. Which statement correctly identifies the student''s error and gives the correct value of k′(2)?', null, md5('apcalcab-mcq-u2n-012-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The student should have subtracted the two product-rule terms; k′(2) = 12·(−1) − 8·4 = −44.', false, 'The product rule adds the terms: 12·(−1) + 8·4 = 20. Subtracting would give −12 − 32 = −44. The student''s actual error was multiplying the derivatives, 12·4 = 48.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student differentiated x³ when only f should be differentiated; k′(2) = 8·4 = 32.', false, 'Both factors must be differentiated, with one term for each. 8·4 = 32 is only the x³f′ term; the full value is 12·(−1) + 8·4 = 20.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The student multiplied the derivatives of the factors; the product rule gives k′(2) = 12·(−1) + 8·4 = 20.', true, 'k′(x) = 3x²·f(x) + x³·f′(x), so k′(2) = 12·(−1) + 8·4 = −12 + 32 = 20. The student computed (x³)′·f′(2) = 12·4 = 48, which is the product of the derivatives, not the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The student should have differentiated only x³; k′(2) = 12·(−1) = −12.', false, '−12 is only the (x³)′f term. The product rule also needs the term x³f′(2) = 8·4 = 32, so k′(2) = −12 + 32 = 20.' from version_ins;
-- apcalcab-mcq-u2n-012-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-012-v2', 'mcq', 'Identify the product rule slip with a square root', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function m is given by m(x) = √x·f(x), with f(4) = 3 and f′(4) = −2. Working at x = 4, a student computes m′(4) = (1/4)(−2) = −1/2. What did the student do wrong, and what is the correct value of m′(4)?', null, md5('apcalcab-mcq-u2n-012-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The student multiplied the derivatives of the two factors; the correct value is m′(4) = (1/4)(3) + 2(−2) = −13/4.', true, 'm′(x) = (1/(2√x))f(x) + √x·f′(x), so m′(4) = (1/4)(3) + 2(−2) = 3/4 − 4 = −13/4. The student multiplied (√x)′ = 1/4 by f′(4) = −2, which is not the product rule.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student differentiated √x when only f should be differentiated; the correct value is m′(4) = 2(−2) = −4.', false, 'Both factors must be differentiated. 2(−2) = −4 is only the √x·f′ term; the full value is 3/4 + (−4) = −13/4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The student should have subtracted the product-rule terms; the correct value is m′(4) = (1/4)(3) − 2(−2) = 19/4.', false, 'The product rule adds the terms: 3/4 + (−4) = −13/4. Subtracting gives 3/4 + 4 = 19/4, a quotient-rule-style sign. The student''s own error was multiplying the derivatives.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The student should have differentiated only √x; the correct value is m′(4) = (1/4)(3) = 3/4.', false, '3/4 is only the (√x)′f term. The product rule also contains √x·f′(4) = 2(−2) = −4, so m′(4) = 3/4 − 4 = −13/4.' from version_ins;
-- apcalcab-mcq-u2n-012-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-012-v3', 'mcq', 'Product rule diagnosis with a logarithm', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose n(x) = f(x)·ln x, where f(e) = 2 and f′(e) = 3. To find n′(e), a student writes n′(e) = f′(e)·(1/e) = 3/e. Which response correctly diagnoses the mistake and states the true value of n′(e)?', null, md5('apcalcab-mcq-u2n-012-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The student should have subtracted the product-rule terms; the correct value is n′(e) = 3·ln e − 2·(1/e) = 3 − 2/e.', false, 'The product rule adds the terms: 3 + 2/e. Subtracting gives 3 − 2/e, a quotient-rule-style sign. The student''s own error was multiplying the derivatives.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student multiplied the derivatives of f and ln x; the product rule gives n′(e) = 3·ln e + 2·(1/e) = 3 + 2/e.', true, 'n′(x) = f′(x)·ln x + f(x)·(1/x), so n′(e) = 3·1 + 2/e = 3 + 2/e. The student multiplied f′(e) by (ln x)′ = 1/e, the product of the derivatives, which is not the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The student should have differentiated only f; the correct value is n′(e) = 3·ln e = 3.', false, '3 is only the f′·ln x term. The product rule also contains f(e)·(1/e) = 2/e, so n′(e) = 3 + 2/e.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The student should have differentiated only ln x; the correct value is n′(e) = 2·(1/e) = 2/e.', false, '2/e is only the f·(ln x)′ term. The product rule also contains f′(e)·ln e = 3·1 = 3, so n′(e) = 3 + 2/e.' from version_ins;
-- apcalcab-mcq-u2n-013-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-013-v1', 'mcq', 'Quotient rule with a quadratic numerator', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = (x² + 3)/(x + 2). What is the value of g′(1)?', null, md5('apcalcab-mcq-u2n-013-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/9', true, 'g′(x) = [2x(x + 2) − (x² + 3)(1)]/(x + 2)². At x = 1: [2(3) − 4]/9 = 2/9.' from version_ins
union all select gen_random_uuid(), id, 'B', '10/9', false, 'This adds the terms in the numerator, 2(1)(3) + 4 = 10, using a product-rule sign. The quotient rule subtracts: 6 − 4 = 2, giving 2/9.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2/9', false, 'This reverses the numerator, (x² + 3) − 2x(x + 2) = 4 − 6 = −2, instead of (low)(d high) − (high)(d low) = 6 − 4 = 2. So g′(1) = 2/9.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/3', false, 'This forgets to square the denominator, using 2/(x + 2) = 2/3. The quotient rule divides by (x + 2)² = 9, giving 2/9.' from version_ins;
-- apcalcab-mcq-u2n-013-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-013-v2', 'mcq', 'Rate of change of a drug concentration', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The concentration of a medication in the bloodstream, in milligrams per liter, is modeled by C(t) = eᵗ/(t + 2), where t is the number of hours after the dose. What is C′(0), the rate of change in milligrams per liter per hour at t = 0?', null, md5('apcalcab-mcq-u2n-013-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/4', false, 'This reverses the numerator, eᵗ − eᵗ(t + 2) = 1 − 2 = −1, instead of eᵗ(t + 2) − eᵗ = 2 − 1 = 1. So C′(0) = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/4', false, 'This adds the terms in the numerator, 2 + 1 = 3, using a product-rule sign. The quotient rule subtracts: 2 − 1 = 1, giving 1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'This divides the derivatives, e⁰/1 = 1, as if (u/v)′ = u′/v′. The quotient rule gives [u′v − uv′]/v² = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/4', true, 'C′(t) = [eᵗ(t + 2) − eᵗ(1)]/(t + 2)². At t = 0: [1(2) − 1(1)]/4 = 1/4.' from version_ins;
-- apcalcab-mcq-u2n-013-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-013-v3', 'mcq', 'Quotient rule with a logarithm', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = (ln x)/x², what is the value of f′(e)?', null, md5('apcalcab-mcq-u2n-013-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/(2e²)', false, 'This divides the derivatives, (1/x)/(2x) = 1/(2x²) = 1/(2e²), as if (u/v)′ = u′/v′. The quotient rule gives −1/e³.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/e³', true, 'f′(x) = [(1/x)x² − (ln x)(2x)]/x⁴ = (1 − 2 ln x)/x³. At x = e: (1 − 2)/e³ = −1/e³.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/e³', false, 'This reverses the numerator, (ln x)(2x) − (1/x)x² = 2e − e = e, instead of (low)(d high) − (high)(d low) = e − 2e = −e. So f′(e) = −e/e⁴ = −1/e³.' from version_ins
union all select gen_random_uuid(), id, 'D', '3/e³', false, 'This adds the terms in the numerator, e + 2e = 3e, using a product-rule sign. The quotient rule subtracts: e − 2e = −e, so f′(e) = −e/e⁴ = −1/e³.' from version_ins;
-- apcalcab-mcq-u2n-014-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-014-v1', 'mcq', 'Horizontal tangents of x²/(x − 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the curve y = x²/(x − 2). Find every x-value at which the tangent line to this curve is horizontal.', null, md5('apcalcab-mcq-u2n-014-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 4 only', false, 'Dividing x² − 4x = 0 by x loses the root x = 0 (x(x − 4) = 0 gives both). At x = 0, y′ = 0 as well.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 0 or x = 4/3', false, 'This adds the terms in the numerator, 2x(x − 2) + x² = 3x² − 4x, whose roots are 0 and 4/3. The quotient rule subtracts: 2x(x − 2) − x² = x² − 4x, whose roots are 0 and 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 2 only', false, 'x = 2 makes the denominator 0, so the curve has a vertical asymptote there and y′ is undefined. Horizontal tangents occur where the numerator x² − 4x = 0, at x = 0 and x = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0 or x = 4', true, 'y′ = [2x(x − 2) − x²(1)]/(x − 2)² = (x² − 4x)/(x − 2)² = x(x − 4)/(x − 2)². The numerator is 0 at x = 0 and x = 4, and neither makes the denominator 0.' from version_ins;
-- apcalcab-mcq-u2n-014-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-014-v2', 'mcq', 'Horizontal tangent of eˣ/x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For which values of x does the graph of y = eˣ/x have a horizontal tangent line?', null, md5('apcalcab-mcq-u2n-014-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There are no such values of x.', false, 'This divides the derivatives, eˣ/1 = eˣ, which is never 0, as if (u/v)′ = u′/v′. The quotient rule gives eˣ(x − 1)/x², which is 0 at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = −1', false, 'This adds the terms in the numerator, eˣ·x + eˣ = eˣ(x + 1), which is 0 at x = −1. The quotient rule subtracts: eˣ·x − eˣ = eˣ(x − 1), which is 0 at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 1', true, 'y′ = [eˣ·x − eˣ(1)]/x² = eˣ(x − 1)/x². Since eˣ is never 0, y′ = 0 only when x − 1 = 0, so x = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0', false, 'The graph has no point at x = 0 because x is in the denominator, and y′ is undefined there. Horizontal tangents occur where the numerator eˣ(x − 1) = 0, at x = 1.' from version_ins;
-- apcalcab-mcq-u2n-014-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-014-v3', 'mcq', 'Horizontal tangent of (x − 3)/x²', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The curve y = (x − 3)/x² is graphed for x ≠ 0. At which value or values of x is its tangent line horizontal?', null, md5('apcalcab-mcq-u2n-014-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 6', true, 'y′ = [(1)x² − (x − 3)(2x)]/x⁴ = (−x² + 6x)/x⁴ = (6 − x)/x³. This is 0 only at x = 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 2', false, 'This adds the terms in the numerator, x² + 2x(x − 3) = 3x² − 6x = 3x(x − 2), whose nonzero root is x = 2. The quotient rule subtracts: x² − 2x(x − 3) = −x² + 6x, giving x = 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0 and x = 6', false, 'Setting the numerator −x² + 6x = 0 gives 0 and 6, but x = 0 is not in the domain of the curve, so there is no tangent line there. Only x = 6 works.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 3', false, 'x = 3 is where y = 0 (the numerator of y), not where y′ = 0. At x = 3, y′ = (6 − 3)/27 = 1/9, so the tangent is not horizontal.' from version_ins;
commit;
