begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u3n-010','apcalcab-mcq-u3n-011','apcalcab-mcq-u3n-012','apcalcab-mcq-u3n-013','apcalcab-mcq-u3n-014','apcalcab-mcq-u3n-015','apcalcab-mcq-u2n-001-v1','apcalcab-mcq-u2n-001-v2','apcalcab-mcq-u2n-001-v3','apcalcab-mcq-u2n-003-v1','apcalcab-mcq-u2n-003-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u3n-010
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-010', 'mcq', 'Derivative of inverse sine with a chain factor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = sin⁻¹(2x), what is f′(1/4)?', null, md5('apcalcab-mcq-u3n-010'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/√3', false, 'This is 1/√(1 − (2x)²) = 1/(√3/2) = 2/√3 at x = 1/4, with no chain-rule factor 2 from d/dx(2x). The correct value is 4/√3.' from version_ins
union all select gen_random_uuid(), id, 'B', '4/√3', true, 'f′(x) = 2/√(1 − (2x)²). At x = 1/4: 1 − 1/4 = 3/4, so f′(1/4) = 2/√(3/4) = 2/(√3/2) = 4/√3.' from version_ins
union all select gen_random_uuid(), id, 'C', '4/√5', false, 'This uses 2/√(1 + 4x²) = 2/√(5/4) = 4/√5, with a plus sign under the radical. The derivative of sin⁻¹ u has 1 − u² under the radical, giving 4/√3.' from version_ins
union all select gen_random_uuid(), id, 'D', '8/3', false, 'This drops the square root: 2/(1 − 4x²) = 2/(3/4) = 8/3. The derivative of sin⁻¹ u has √(1 − u²) in the denominator, giving 4/√3.' from version_ins;
-- apcalcab-mcq-u3n-011
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-011', 'mcq', 'Derivative of inverse tangent', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = tan⁻¹(5x), what is f′(x)?', null, md5('apcalcab-mcq-u3n-011'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/√(1 − 25x²)', false, 'This uses the derivative of sin⁻¹(5x), not tan⁻¹(5x). The derivative of tan⁻¹ u has u′/(1 + u²), with no radical.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/(1 + 25x²)', false, 'This keeps the denominator 1 + (5x)² but omits the chain-rule factor u′ = 5 in the numerator.' from version_ins
union all select gen_random_uuid(), id, 'C', '5/(1 + 5x²)', false, 'This squares only x, not 5x: (5x)² = 25x², so the denominator is 1 + 25x².' from version_ins
union all select gen_random_uuid(), id, 'D', '5/(1 + 25x²)', true, 'd/dx tan⁻¹ u = u′/(1 + u²) with u = 5x, u′ = 5, so f′(x) = 5/(1 + 25x²).' from version_ins;
-- apcalcab-mcq-u3n-012
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-012', 'mcq', 'Which differentiation rules apply', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following correctly identifies the rules needed to differentiate f(x) = x² ln(5x + 1)?', null, md5('apcalcab-mcq-u3n-012'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Quotient Rule, with the Chain Rule for ln(5x + 1)', false, 'f is a product, not a quotient: no function is divided by another. The quotient rule does not apply, although the chain rule is needed for ln(5x + 1).' from version_ins
union all select gen_random_uuid(), id, 'B', 'Product Rule, with the Chain Rule for ln(5x + 1)', true, 'f is a product of x² and ln(5x + 1). The factor ln(5x + 1) is a composite function, so its derivative uses the chain rule: 5/(5x + 1). Thus f′(x) = 2x ln(5x + 1) + 5x²/(5x + 1).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Chain Rule only, with x² as the inner function', false, 'The expression is a product of x² and ln(5x + 1), not a function evaluated at x². The chain rule alone does not account for both factors; the product rule is needed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Product Rule only', false, 'The product rule is needed, but ln(5x + 1) is a composite function whose derivative is 5/(5x + 1), not 1/(5x + 1). Without the chain rule the factor 5 is lost.' from version_ins;
-- apcalcab-mcq-u3n-013
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-013', 'mcq', 'Quotient rule with an exponential composite', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = e^(2x)/(x + 1), what is f′(1)?', null, md5('apcalcab-mcq-u3n-013'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3e²/4', true, 'f′(x) = (2e^(2x)(x + 1) − e^(2x) · 1)/(x + 1)². At x = 1: (2e² · 2 − e²)/4 = 3e²/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '3e²/2', false, 'The numerator 3e² is correct, but the denominator was (x + 1) = 2 instead of (x + 1)² = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3e²/4', false, 'This reverses the quotient rule numerator to f · g′ − f′ · g, giving (e² − 4e²)/4 = −3e²/4. The numerator must be f′ · g − f · g′.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e²/4', false, 'This differentiates e^(2x) as e^(2x), omitting the factor 2: (e² · 2 − e²)/4 = e²/4. The chain rule gives 2e^(2x), so the numerator is 4e² − e² = 3e².' from version_ins;
-- apcalcab-mcq-u3n-014
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-014', 'mcq', 'Identify the error in a product derivative', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student writes: d/dx[x² e^(3x)] = (2x)(3e^(3x)) = 6x e^(3x). Which statement correctly describes the student''s error?', null, md5('apcalcab-mcq-u3n-014'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The Quotient Rule is required because e^(3x) is not a polynomial.', false, 'The expression is a product, not a quotient, and the quotient rule is for division. The product rule is the correct tool, whether or not a factor is a polynomial.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The derivative of x² should be x, not 2x.', false, 'The power rule gives d/dx[x²] = 2x, so the student''s factor 2x was correct. The error was combining the factors by multiplication rather than the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The chain rule should not be used, since d/dx[e^(3x)] = e^(3x).', false, 'The chain rule is needed: d/dx[e^(3x)] = 3e^(3x). The student''s factor 3e^(3x) was correct; the product structure was wrong.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It multiplies the derivatives; the product rule gives 2x·e^(3x) + x²·3e^(3x).', true, 'The student multiplied the derivatives of the two factors. The product rule gives (x²)′ e^(3x) + x² (e^(3x))′ = 2x e^(3x) + 3x² e^(3x). Both derivatives used, 2x and 3e^(3x), were correct.' from version_ins;
-- apcalcab-mcq-u3n-015
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-015', 'mcq', 'Second derivative of a Gaussian', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = e^(−x²), what is f″(1)?', null, md5('apcalcab-mcq-u3n-015'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/e', true, 'f′(x) = −2x e^(−x²). By the product rule, f″(x) = −2e^(−x²) + (−2x)(−2x)e^(−x²) = (4x² − 2)e^(−x²). At x = 1: 2e⁻¹ = 2/e.' from version_ins
union all select gen_random_uuid(), id, 'B', '4/e', false, 'This keeps only the term 4x² e^(−x²) = 4/e at x = 1 and omits −2e^(−x²), the term from differentiating −2x. Adding both terms gives 2/e.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2/e', false, 'This differentiates only the factor −2x and treats e^(−x²) as constant: f″ = −2e^(−x²), which is −2/e at x = 1. The product rule also needs −2x · (−2x)e^(−x²).' from version_ins
union all select gen_random_uuid(), id, 'D', '−4/e', false, 'This differentiates e^(−x²) as e^(−x²) without the chain-rule factor −2x: f″ = −2e^(−x²) − 2x e^(−x²) = −4/e at x = 1. The correct second term is +4x² e^(−x²).' from version_ins;
-- apcalcab-mcq-u2n-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-001-v1', 'mcq', 'Average rate of tank volume', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The volume of water in a tank is V(t) = t² + 4t liters, where t is measured in minutes. What is the average rate of change of the volume from t = 1 to t = 5 minutes?', null, md5('apcalcab-mcq-u2n-001-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40 liters per minute', false, '40 is the change in volume, V(5) − V(1) = 45 − 5 = 40 liters, which was not divided by the elapsed time 5 − 1 = 4; the average rate is 40/4 = 10.' from version_ins
union all select gen_random_uuid(), id, 'B', '14 liters per minute', false, '14 is the instantaneous rate V′(5) = 2(5) + 4 = 14 at the right endpoint, not the average rate over [1, 5], which is 10.' from version_ins
union all select gen_random_uuid(), id, 'C', '6 liters per minute', false, '6 is the instantaneous rate V′(1) = 2(1) + 4 = 6 at the left endpoint, not the average rate over [1, 5], which is 40/4 = 10.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 liters per minute', true, 'V(5) = 25 + 20 = 45 and V(1) = 1 + 4 = 5, so the average rate is (45 − 5)/(5 − 1) = 40/4 = 10 liters per minute.' from version_ins;
-- apcalcab-mcq-u2n-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-001-v2', 'mcq', 'Average rate of a square root', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the function g(x) = √x, find the average rate of change of g as x increases from 1 to 9.', null, md5('apcalcab-mcq-u2n-001-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, '2 is the change g(9) − g(1) = 3 − 1 = 2, which was not divided by 9 − 1 = 8; the average rate is 2/8 = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/6', false, '1/6 is the instantaneous rate g′(9) = 1/(2√9) = 1/6 at the right endpoint, not the average rate over [1, 9], which is 1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/4', true, 'g(9) = 3 and g(1) = 1, so the average rate of change is (3 − 1)/(9 − 1) = 2/8 = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, '1/2 is the instantaneous rate g′(1) = 1/(2√1) = 1/2 at the left endpoint, not the average rate over [1, 9], which is 1/4.' from version_ins;
-- apcalcab-mcq-u2n-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-001-v3', 'mcq', 'Secant slope of a cubic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find the slope of the secant line to the graph of h(x) = x³ − x through the points where x = 0 and x = 3.', null, md5('apcalcab-mcq-u2n-001-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '26', false, '26 is the tangent slope h′(3) = 3(9) − 1 = 26 at x = 3, not the slope of the secant through x = 0 and x = 3, which is 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', false, '12 is the mean of the endpoint outputs, (h(0) + h(3))/2 = (0 + 24)/2 = 12, which is not a rate of change; the slope is 24/3 = 8.' from version_ins
union all select gen_random_uuid(), id, 'C', '24', false, '24 is the change h(3) − h(0) = 24, which was not divided by 3 − 0 = 3; the slope is 24/3 = 8.' from version_ins
union all select gen_random_uuid(), id, 'D', '8', true, 'h(3) = 27 − 3 = 24 and h(0) = 0, so the slope is (24 − 0)/(3 − 0) = 8.' from version_ins;
-- apcalcab-mcq-u2n-003-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-003-v1', 'mcq', 'Limit definition with ln x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = ln x. The limit lim(h→0) [ln(2 + h) − ln 2] / h is the derivative f′(2). What is its value?', null, md5('apcalcab-mcq-u2n-003-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4', false, '1/4 comes from using 1/x² as the derivative of ln x, so that f′(2) = 1/2² = 1/4. The derivative of ln x is 1/x, so f′(2) = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2', true, 'The quotient [f(2 + h) − f(2)]/h with f(x) = ln x is the definition of f′(2). Since f′(x) = 1/x, f′(2) = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'Substituting h = 0 gives ln 2 − ln 2 = 0 in the numerator and 0 in the denominator, which is the indeterminate form 0/0, not 0. The limit is f′(2) = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, '2 comes from inverting the derivative, using x instead of 1/x. The derivative of ln x is 1/x, so f′(2) = 1/2, not 2.' from version_ins;
-- apcalcab-mcq-u2n-003-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-003-v2', 'mcq', 'Limit definition with 1/x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Evaluate lim(h→0) [1/(3 + h) − 1/3] / h, which is the derivative of f(x) = 1/x at x = 3.', null, md5('apcalcab-mcq-u2n-003-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/3', false, '−1/3 comes from using −1/x for the derivative, lowering the coefficient but not the exponent. The exponent must become −2, so f′(3) = −1/3² = −1/9.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/9', false, '1/9 loses the negative sign. The power rule gives d/dx (x⁻¹) = −x⁻², so f′(3) = −1/9.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'Substituting h = 0 gives 1/3 − 1/3 = 0 over 0, which is 0/0 and indeterminate, not 0. The limit is f′(3) = −1/9.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/9', true, 'This is f′(3) for f(x) = x⁻¹. Since f′(x) = −x⁻² = −1/x², f′(3) = −1/9.' from version_ins;
commit;
