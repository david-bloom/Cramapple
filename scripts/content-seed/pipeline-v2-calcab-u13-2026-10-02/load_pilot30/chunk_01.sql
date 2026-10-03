begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-sv-006-v1','apcalcab-mcq-sv-006-v2','apcalcab-mcq-sv-006-v3','apcalcab-mcq-sv-025-v1','apcalcab-mcq-sv-025-v2','apcalcab-mcq-sv-025-v3','apcalcab-mcq-sv-026-v3','apcalcab-mcq-sv-026-v4','apcalcab-mcq-sv-026-v5','apcalcab-mcq-sv-027-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-sv-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-006-v1', 'mcq', 'Tangent Line to a Square-Root Curve', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ramp''s profile follows the curve y = √x. Which equation describes the line tangent to the profile at the point where x = 9?', null, md5('apcalcab-mcq-sv-006-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 3 + (x − 9)/3', false, 'Uses 1/√x = 1/3 as the slope, dropping the factor 1/2 in the derivative of √x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 3 + (x − 9)/6', true, 'At x = 9 the point is (9, 3), and dy/dx = 1/(2√x) = 1/6 there, so the tangent line is y = 3 + (x − 9)/6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = (x − 9)/6', false, 'Has the correct slope 1/6 but leaves out the y-coordinate 3 of the point of tangency.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 3 + 6(x − 9)', false, 'Uses 6, the reciprocal of the slope 1/6, as the slope of the tangent line.' from version_ins;
-- apcalcab-mcq-sv-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-006-v2', 'mcq', 'Tangent Line to a Product Curve', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find an equation of the tangent line to y = x·e^x at x = 1.', null, md5('apcalcab-mcq-sv-006-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = e + e(x − 1)', false, 'Differentiates only the exponential factor, using the slope x·e^x = e at x = 1 instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 2e(x − 1)', false, 'Has the correct slope 2e but leaves out the y-coordinate e of the point of tangency.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = e + 2e(x − 1)', true, 'At x = 1 the point is (1, e). By the product rule, dy/dx = (1 + x)e^x, which is 2e at x = 1, so the tangent line is y = e + 2e(x − 1).' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = e + (1 + e)(x − 1)', false, 'Adds the derivatives of the two factors, 1 + e^x = 1 + e at x = 1, instead of applying the product rule.' from version_ins;
-- apcalcab-mcq-sv-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-006-v3', 'mcq', 'Tangent Line to a Reciprocal Curve', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The hyperbola y = 1/x passes through the point with x-coordinate 2. Which equation describes the tangent line to the hyperbola there?', null, md5('apcalcab-mcq-sv-006-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 1/2 − (x − 2)/4', true, 'At x = 2 the point is (2, 1/2). Since dy/dx = −1/x², the slope is −1/4, so the tangent line is y = 1/2 − (x − 2)/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 2 − (x − 2)/4', false, 'Has the correct slope −1/4 but uses 2 as the y-coordinate of the point of tangency instead of 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 1/2 − (x − 2)/2', false, 'Divides by x instead of x² when differentiating 1/x, giving slope −1/2 instead of −1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 1/2 + (x − 2)/4', false, 'Has the right size of slope but loses the negative sign in dy/dx = −1/x².' from version_ins;
-- apcalcab-mcq-sv-025-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-025-v1', 'mcq', 'Limit Form of the Derivative of a Cubic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = x³, which of the following limits is equal to f′(2)?', null, md5('apcalcab-mcq-sv-025-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(h→0) [(2+h)³ − 8]/2', false, 'Divides by the fixed point 2 instead of the increment h. The numerator tends to 0, so this limit is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(h→0) [(2+h)³ − 8]/(2h)', false, 'Divides by 2h instead of h. The limit is 6, half of f′(2) = 12.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(h→0) [(2+h)³ − h³]/h', false, 'Subtracts f(h) = h³ where f(2) = 8 belongs. The quotient is (8 + 12h + 6h²)/h, which tends to +∞ as h → 0⁺ and to −∞ as h → 0⁻, so the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(h→0) [(2+h)³ − 8]/h', true, 'This is [f(2 + h) − f(2)]/h with f(2) = 8, the limit definition of f′(2). It equals 12.' from version_ins;
-- apcalcab-mcq-sv-025-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-025-v2', 'mcq', 'Limit Form of the Derivative of a Reciprocal', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If g(x) = 1/x, which of the following limits is equal to g′(4)?', null, md5('apcalcab-mcq-sv-025-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→4) [1/x − 1/4]/(x − 4)', true, 'This is [g(x) − g(4)]/(x − 4), the x → a form of the definition of g′(4). It equals −1/16.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→4) [1/x − 4]/(x − 4)', false, 'Uses 4, the input, where g(4) = 1/4 belongs. The numerator tends to −15/4 while the denominator tends to 0, so the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→0) [1/x − 1/4]/(x − 4)', false, 'Lets x approach 0 instead of 4. Because 1/x is unbounded near 0, the one-sided limits differ and the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→4) [1/x − 1/4]/4', false, 'Divides by the fixed value 4 instead of x − 4. The numerator tends to 0, so this limit is 0.' from version_ins;
-- apcalcab-mcq-sv-025-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-025-v3', 'mcq', 'Instantaneous Rate as a Limit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The volume of a balloon is V(t) = 4t² cubic centimeters at time t seconds. Which of the following limits is equal to the instantaneous rate of change of V at t = 5?', null, md5('apcalcab-mcq-sv-025-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(h→0) [4(5+h)² − 4h²]/h', false, 'Subtracts V(h) = 4h² where V(5) = 100 belongs. The quotient is (100 + 40h)/h, which tends to +∞ as h → 0⁺ and to −∞ as h → 0⁻, so the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(h→0) [4(5+h)² − 100]/h', true, 'This is [V(5 + h) − V(5)]/h with V(5) = 100, the definition of V′(5). It equals 40 cubic centimeters per second.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(h→0) [4(5+h)² − 100]/(5h)', false, 'Divides by 5h instead of h. The limit is 8, one fifth of V′(5) = 40.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(h→0) [4(5+h)² − 100]/5', false, 'Divides by the fixed time 5 instead of the increment h. The numerator tends to 0, so this limit is 0.' from version_ins;
-- apcalcab-mcq-sv-026-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-026-v3', 'mcq', 'Derivative of a Logarithmic Product at e', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = x³ ln x, what is f′(e)?', null, md5('apcalcab-mcq-sv-026-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4e²', true, 'By the product rule, f′(x) = 3x² ln x + x³·(1/x) = 3x² ln x + x². At x = e, ln e = 1, so f′(e) = 3e² + e² = 4e².' from version_ins
union all select gen_random_uuid(), id, 'B', '3e² + 1/e', false, 'Writes the second product-rule term as 1/x instead of x³·(1/x) = x², forgetting to keep the factor x³.' from version_ins
union all select gen_random_uuid(), id, 'C', '3e', false, 'Multiplies the derivatives of the two factors, 3x² and 1/x, getting 3x, which is 3e at x = e.' from version_ins
union all select gen_random_uuid(), id, 'D', '3e²', false, 'Keeps only the term 3x² ln x and drops the second product-rule term x³·(1/x) = x², which contributes e² at x = e.' from version_ins;
-- apcalcab-mcq-sv-026-v4
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-026-v4', 'mcq', 'Derivative of a Trigonometric Product at Pi', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = (x² + 1) sin x, what is f′(π)?', null, md5('apcalcab-mcq-sv-026-v4'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π² + 1', false, 'Uses cos π = 1 instead of −1 when evaluating (x² + 1) cos x at π.' from version_ins
union all select gen_random_uuid(), id, 'B', '−(π² + 1)', true, 'By the product rule, f′(x) = 2x sin x + (x² + 1) cos x. At x = π, sin π = 0 and cos π = −1, so f′(π) = −(π² + 1).' from version_ins
union all select gen_random_uuid(), id, 'C', '−2π', false, 'Multiplies the derivatives of the two factors, 2x and cos x, getting 2π cos π = −2π, instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Keeps only the first product-rule term 2x sin x, which is 0 at π, and leaves out (x² + 1) cos x.' from version_ins;
-- apcalcab-mcq-sv-026-v5
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-026-v5', 'mcq', 'Derivative of a Polynomial-Exponential Product at 2', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = (x² − 3)eˣ, what is f′(2)?', null, md5('apcalcab-mcq-sv-026-v5'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e²', false, 'Differentiates only the factor eˣ, leaving (x² − 3)eˣ, which equals 1·e² = e² at x = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '5e²', true, 'By the product rule, f′(x) = 2x eˣ + (x² − 3)eˣ. At x = 2 this is 4e² + 1·e² = 5e².' from version_ins
union all select gen_random_uuid(), id, 'C', '4e²', false, 'Multiplies the derivatives of the two factors, 2x and eˣ, getting 2·2·e² = 4e², instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 + e²', false, 'Adds the derivatives of the two factors, 2x + eˣ, which is 4 + e² at x = 2, instead of applying the product rule.' from version_ins;
-- apcalcab-mcq-sv-027-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-027-v1', 'mcq', 'Product of Cosecant and Cotangent', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is d/dx[csc x cot x]?', null, md5('apcalcab-mcq-sv-027-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'csc x(csc²x − cot²x)', false, 'Uses +csc²x as the derivative of cot x (sign error), so the second term is +csc³x instead of −csc³x.' from version_ins
union all select gen_random_uuid(), id, 'B', '−cot x(csc²x + cot²x)', false, 'The two product-rule terms are −csc x cot²x and −csc³x, whose common factor is csc x, not cot x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'csc x(cot²x + csc²x)', false, 'Uses +csc x cot x and +csc²x as the derivatives of csc x and cot x, dropping both negative signs.' from version_ins
union all select gen_random_uuid(), id, 'D', '−csc x(cot²x + csc²x)', true, 'By the product rule, d/dx[csc x cot x] = (−csc x cot x)(cot x) + (csc x)(−csc²x) = −csc x(cot²x + csc²x).' from version_ins;
commit;
