begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u2n-001','apcalcab-mcq-u2n-003','apcalcab-mcq-u2n-004','apcalcab-mcq-u2n-005','apcalcab-mcq-u2n-006','apcalcab-mcq-u2n-007','apcalcab-mcq-u2n-008','apcalcab-mcq-u2n-009','apcalcab-mcq-u2n-010','apcalcab-mcq-u2n-011','apcalcab-mcq-u2n-012'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u2n-001
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-001', 'mcq', 'Average rate on an interval', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x² − 3x. What is the average rate of change of f over the interval [1, 4]?', null, md5('apcalcab-mcq-u2n-001'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1', false, '−1 is the instantaneous rate f′(1) = 2(1) − 3 = −1 at the left endpoint, not the average rate over [1, 4], which is 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', true, 'f(4) = 16 − 12 = 4 and f(1) = 1 − 3 = −2, so the average rate of change is (4 − (−2))/(4 − 1) = 6/3 = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, '6 is the change in f, f(4) − f(1) = 4 − (−2) = 6, but it was not divided by the change in x, 4 − 1 = 3; the average rate is 6/3 = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, '5 is the instantaneous rate f′(4) = 2(4) − 3 = 5 at the right endpoint, not the average rate over [1, 4], which is 2.' from version_ins;
-- apcalcab-mcq-u2n-003
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-003', 'mcq', 'Limit as a derivative', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √x. Using the limit definition of the derivative, evaluate f′(9) = lim(h→0) [√(9 + h) − 3] / h.', null, md5('apcalcab-mcq-u2n-003'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/6', true, 'This limit is the definition of f′(9) for f(x) = √x, since f(9 + h) − f(9) = √(9 + h) − 3. Because f′(x) = 1/(2√x), f′(9) = 1/(2·3) = 1/6.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/3', false, '1/3 comes from using the derivative of √x as 1/√x, forgetting the factor 1/2. The correct derivative is 1/(2√x), so the limit is 1/(2·3) = 1/6.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, '6 comes from inverting the derivative, 2√9 = 6. The derivative of √x at 9 is 1/(2√9) = 1/6, not its reciprocal.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Substituting h = 0 gives 0/0, which is indeterminate rather than 0. The limit is the derivative of √x at x = 9, namely 1/6.' from version_ins;
-- apcalcab-mcq-u2n-004
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-004', 'mcq', 'Estimate derivative from table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Selected values of a differentiable function f are given in the table.

x:    0   2    5    6
f(x): 3   7   16   18

Using the two table values closest to x = 4 on either side, what is the best estimate of f′(4)?', null, md5('apcalcab-mcq-u2n-004'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9', false, '9 is the change f(5) − f(2) = 16 − 7 = 9, but the slope requires dividing by 5 − 2 = 3, giving 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, '2 is the slope over [5, 6], (18 − 16)/(6 − 5) = 2. That interval does not contain x = 4; the closest points on either side are x = 2 and x = 5, giving 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '9/7', false, '9/7 divides f(5) − f(2) = 9 by 5 + 2 = 7. The change in x is 5 − 2 = 3, so the estimate is 9/3 = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'The closest table values on either side of x = 4 are x = 2 and x = 5, so f′(4) ≈ (f(5) − f(2))/(5 − 2) = (16 − 7)/3 = 3.' from version_ins;
-- apcalcab-mcq-u2n-005
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-005', 'mcq', 'Differentiability at a corner', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x² for x ≤ 2, and f(x) = 3x − 2 for x > 2. Which statement about f at x = 2 is true?', null, md5('apcalcab-mcq-u2n-005'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is not continuous at x = 2 because the slopes of the pieces differ.', false, 'Continuity concerns function values, not slopes. The left limit is 4, the right limit is 4, and f(2) = 4, so f is continuous at 2; the differing slopes only prevent differentiability.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is continuous at x = 2 but not differentiable there.', true, 'Both pieces equal 4 at x = 2 (2² = 4 and 3(2) − 2 = 4), so f is continuous. The left slope is 2x = 4 while the right slope is 3, so the one-sided derivatives differ and f′(2) does not exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is differentiable at x = 2 because each piece is a polynomial.', false, 'Each piece is differentiable on its own domain, but at the join the left derivative is 4 and the right derivative is 3. They are unequal, so f is not differentiable at 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is differentiable at x = 2 because f is continuous there.', false, 'f is continuous at 2, but continuity does not imply differentiability. The one-sided slopes are 4 (left) and 3 (right), so f′(2) does not exist.' from version_ins;
-- apcalcab-mcq-u2n-006
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-006', 'mcq', 'Power rule with negative exponent', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = 3/x², which of the following is f′(x)?', null, md5('apcalcab-mcq-u2n-006'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3/x³', false, 'This gets the new exponent −3 right but keeps the coefficient 3 (with a negative sign) instead of multiplying 3 by the exponent −2. The power rule gives 3(−2)x⁻³ = −6/x³.' from version_ins
union all select gen_random_uuid(), id, 'B', '6/x³', false, 'This loses the negative sign from the exponent −2. The power rule gives 3(−2)x⁻³ = −6/x³.' from version_ins
union all select gen_random_uuid(), id, 'C', '−6/x³', true, 'Rewrite f(x) = 3x⁻². Then f′(x) = 3(−2)x⁻³ = −6x⁻³ = −6/x³.' from version_ins
union all select gen_random_uuid(), id, 'D', '−6/x', false, 'This adds 1 to the exponent (−2 + 1 = −1) instead of subtracting 1. The new exponent is −3, so f′(x) = −6/x³.' from version_ins;
-- apcalcab-mcq-u2n-007
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-007', 'mcq', 'Horizontal tangent with fractional powers', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, let f(x) = x^(3/2) − 12x^(1/2). At what value of x does the graph of f have a horizontal tangent line?', null, md5('apcalcab-mcq-u2n-007'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 4', true, 'f′(x) = (3/2)x^(1/2) − 6x^(−1/2). Setting this to 0: (3/2)√x = 6/√x, so (3/2)x = 6 and x = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 8', false, 'This uses the derivative of 12x^(1/2) as 12x^(−1/2) (missing the factor 1/2). Then (3/2)√x = 12/√x gives x = 8, but the correct term is 6x^(−1/2), which gives x = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 12', false, 'This solves f(x) = 0 (x^(3/2) = 12x^(1/2) gives x = 12) rather than f′(x) = 0. A horizontal tangent requires f′(x) = 0, which gives x = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 6', false, 'This differentiates x^(3/2) as x^(1/2) (missing the factor 3/2). Then √x = 6/√x gives x = 6, but the correct first term is (3/2)x^(1/2), which gives x = 4.' from version_ins;
-- apcalcab-mcq-u2n-008
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-008', 'mcq', 'Constant multiple and difference rule', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f′(2) = 4, and let g(x) = 2f(x) − 3x. What is g′(2)?', null, md5('apcalcab-mcq-u2n-008'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '11', false, 'This adds instead of subtracting, 2(4) + 3 = 11. The difference rule gives 2f′(2) − 3 = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This differentiates 3x as 3x, giving 2(4) − 3(2) = 2. The derivative of 3x is the constant 3, so g′(2) = 8 − 3 = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', true, 'g′(x) = 2f′(x) − 3, so g′(2) = 2(4) − 3 = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This drops the constant multiple 2 on f, giving 4 − 3 = 1. The constant multiple rule gives 2f′(2) = 8, so g′(2) = 8 − 3 = 5.' from version_ins;
-- apcalcab-mcq-u2n-009
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-009', 'mcq', 'Derivative of e^x and cos x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = 4e^x − 2cos x, what is f′(π/2)?', null, md5('apcalcab-mcq-u2n-009'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2πe^(π/2 − 1)', false, 'This combines two errors. It treats e^x like a power function (4·(π/2)·e^(π/2 − 1) = 2πe^(π/2 − 1)) and it drops the cosine term, which contributes +2. The derivative of e^x is e^x, so the first term is 4e^(π/2), and the full answer is 4e^(π/2) + 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '4e^(π/2) − 2', false, 'This uses (cos x)′ = sin x instead of −sin x. The correct derivative is 4e^x − 2(−sin x) = 4e^x + 2sin x, giving 4e^(π/2) + 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '4e^(π/2) + 2', true, 'f′(x) = 4e^x + 2sin x, so f′(π/2) = 4e^(π/2) + 2sin(π/2) = 4e^(π/2) + 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '4e^(π/2)', false, 'This uses (cos x)′ = −cos x, so the cosine term becomes +2cos(π/2) = 0. The derivative of cos x is −sin x, so that term contributes +2sin(π/2) = 2 and f′(π/2) = 4e^(π/2) + 2.' from version_ins;
-- apcalcab-mcq-u2n-010
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-010', 'mcq', 'Derivative with ln x and a reciprocal', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 5 ln x − 2/x for x > 0. What is g′(2)?', null, md5('apcalcab-mcq-u2n-010'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7/2', false, 'This differentiates −2x⁻¹ as +2x⁻¹ without lowering the exponent, giving 5/2 + 2/2 = 7/2. The power rule gives +2x⁻² = 2/4 at x = 2, so g′(2) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This uses −2/x² for the derivative of −2/x, giving 5/2 − 2/4 = 2. But d/dx(−2x⁻¹) = +2x⁻², so the term is +2/4 and g′(2) = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '5/2', false, 'This differentiates 5 ln x correctly as 5/x = 5/2 but treats −2/x as having derivative 0. The second term contributes +2/x² = 1/2, so g′(2) = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'g′(x) = 5/x + 2/x² (since −2/x = −2x⁻¹ has derivative +2x⁻²). Then g′(2) = 5/2 + 2/4 = 5/2 + 1/2 = 3.' from version_ins;
-- apcalcab-mcq-u2n-011
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-011', 'mcq', 'Product rule at a point', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² + 1)(3x − 2). What is f′(2)?', null, md5('apcalcab-mcq-u2n-011'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '31', true, 'By the product rule, f′(x) = 2x(3x − 2) + (x² + 1)(3). At x = 2: 4(4) + 5(3) = 16 + 15 = 31.' from version_ins
union all select gen_random_uuid(), id, 'B', '16', false, 'This keeps only u′v = 4·4 = 16 and omits the second term uv′ = 5·3 = 15. The product rule requires both terms, so f′(2) = 31.' from version_ins
union all select gen_random_uuid(), id, 'C', '12', false, 'This multiplies the derivatives of the factors, (2x)(3) = 12 at x = 2. The product rule is u′v + uv′ = 31, not u′v′.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This subtracts the terms, u′v − uv′ = 16 − 15 = 1, which is a quotient-rule-style sign. The product rule adds them: 16 + 15 = 31.' from version_ins;
-- apcalcab-mcq-u2n-012
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-012', 'mcq', 'Identify product rule error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = x²·f(x), where f(3) = 2 and f′(3) = −1. A student writes h′(3) = (2·3)(−1) = −6. Which statement correctly identifies the student''s error and gives the correct value of h′(3)?', null, md5('apcalcab-mcq-u2n-012'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The student differentiated x² when only f should be differentiated; h′(3) = 9·(−1) = −9.', false, 'Both factors must be differentiated, with one term for each. The correct value is 6·2 + 9·(−1) = 3, not −9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student made only a sign error; the correct value is h′(3) = 6.', false, 'The error is not a sign slip: −6 is (x²)′·f′(3), the product of derivatives, which is not the product rule. The correct value is 12 − 9 = 3, not 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The student omitted f′ from the work; the correct value is h′(3) = 2·3·2 = 12.', false, 'The student did use f′(3) = −1. The real error is multiplying the derivatives; the product rule has two terms, 6·2 and 9·(−1), and the second term cannot be dropped, so h′(3) = 12 − 9 = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The student multiplied the derivatives of the factors; the product rule gives h′(3) = 2·3·2 + 9·(−1) = 3.', true, 'h′(x) = 2x·f(x) + x²·f′(x), so h′(3) = 6·2 + 9·(−1) = 12 − 9 = 3. The student computed (x²)′·f′ = 6·(−1), which is not the product rule.' from version_ins;
commit;
