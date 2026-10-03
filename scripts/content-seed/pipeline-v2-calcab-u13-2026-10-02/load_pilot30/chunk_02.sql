begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-sv-027-v2','apcalcab-mcq-sv-027-v3','apcalcab-mcq-sv-028-v1','apcalcab-mcq-sv-028-v2','apcalcab-mcq-sv-028-v3','apcalcab-mcq-sv-005-v3','apcalcab-mcq-sv-005-v4','apcalcab-mcq-sv-005-v5','apcalcab-mcq-sv-007-v3','apcalcab-mcq-sv-007-v4'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-sv-027-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-027-v2', 'mcq', 'Power Times Secant', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is d/dx[x² sec x]?', null, md5('apcalcab-mcq-sv-027-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x sec x(2 + tan x)', false, 'Writes the second product-rule term as x sec x tan x, losing one factor of x from x².' from version_ins
union all select gen_random_uuid(), id, 'B', '2x sec x tan x', false, 'Multiplies the derivatives of the two factors, 2x and sec x tan x, instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x sec x(2 − x tan x)', false, 'Uses −sec x tan x as the derivative of sec x (sign error).' from version_ins
union all select gen_random_uuid(), id, 'D', 'x sec x(2 + x tan x)', true, 'By the product rule, d/dx[x² sec x] = 2x sec x + x² sec x tan x = x sec x(2 + x tan x).' from version_ins;
-- apcalcab-mcq-sv-027-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-027-v3', 'mcq', 'Power Times Cosine', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If g(x) = x² cos x, find g′(x).', null, md5('apcalcab-mcq-sv-027-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x cos x − x² sin x', true, 'By the product rule, g′(x) = (2x)(cos x) + (x²)(−sin x) = 2x cos x − x² sin x.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2x sin x', false, 'Multiplies the derivatives of the two factors, 2x and −sin x, instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '−x² sin x', false, 'Keeps only the term x²(−sin x) and leaves out (2x)(cos x).' from version_ins
union all select gen_random_uuid(), id, 'D', '2x cos x + x² sin x', false, 'Uses +sin x as the derivative of cos x (sign error).' from version_ins;
-- apcalcab-mcq-sv-028-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-028-v1', 'mcq', 'Absolute Value at a Corner', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = |x − 2|. Which of the following statements is true?', null, md5('apcalcab-mcq-sv-028-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is continuous at x = 2 but not differentiable at x = 2.', true, 'f(2) = 0 and f(x) approaches 0 from both sides, so f is continuous at 2. The slope is −1 to the left of 2 and +1 to the right, so the graph has a corner and f′(2) does not exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is differentiable at x = 2 but not continuous at x = 2.', false, 'A function that is differentiable at a point must be continuous there, so this combination cannot occur.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is neither continuous nor differentiable at x = 2.', false, 'f is continuous at 2: f(2) = 0 and both one-sided limits equal 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is both continuous and differentiable at x = 2.', false, 'The one-sided slopes are −1 and +1, which differ, so f is not differentiable at x = 2 even though it is continuous.' from version_ins;
-- apcalcab-mcq-sv-028-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-028-v2', 'mcq', 'Piecewise Function That Joins Smoothly', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g is defined by g(x) = x² for x ≤ 1 and g(x) = 2x − 1 for x > 1. Which statement about g at x = 1 is true?', null, md5('apcalcab-mcq-sv-028-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g′(1) exists, but g is not continuous at 1.', false, 'A function that is differentiable at a point must be continuous there. Also, both pieces equal 1 at x = 1, so g is continuous.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is continuous at 1, but g′(1) does not exist because the graph has a corner.', false, 'The one-sided derivatives are both 2, so the graph has no corner at x = 1; g is differentiable there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is continuous at 1, and g′(1) = 2.', true, 'Both pieces equal 1 at x = 1, so g is continuous. The left derivative 2x is 2 at x = 1 and the right derivative is 2, so they agree and g′(1) = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g has a jump discontinuity at 1, so g′(1) does not exist.', false, 'Both pieces equal 1 at x = 1, so there is no jump and g is continuous. The one-sided derivatives are both 2, so g′(1) exists.' from version_ins;
-- apcalcab-mcq-sv-028-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-028-v3', 'mcq', 'Piecewise Function With a Jump', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = x² for x < 1 and h(x) = x + 2 for x ≥ 1. Which of the following statements is true?', null, md5('apcalcab-mcq-sv-028-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h is continuous at x = 1 but not differentiable there because the slopes of the two pieces differ.', false, 'h is not continuous at x = 1 (left limit 1, h(1) = 3), so the first claim is false. Comparing the slopes of the two pieces is not the test: the jump already rules out differentiability.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h is continuous at x = 1 because h(1) is defined.', false, 'Continuity also requires the limit to equal h(1). The left-hand limit is 1 while h(1) = 3, so h is not continuous at 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h is not differentiable at x = 1 because h is not continuous at x = 1.', true, 'As x approaches 1 from the left, h(x) approaches 1, but h(1) = 3, so h has a jump at x = 1. A function that is not continuous at a point cannot be differentiable there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h is differentiable at x = 1 because each piece is differentiable.', false, 'Each piece is differentiable on its own interval, but that says nothing about x = 1, where the two pieces do not meet (1 versus 3).' from version_ins;
-- apcalcab-mcq-sv-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-005-v3', 'mcq', 'Damped Voltage Signal', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A damped voltage signal is modeled by D(x) = e^(−4x) cos x. What is D′(x)?', null, md5('apcalcab-mcq-sv-005-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e^(−4x)(4 cos x − sin x)', false, 'Loses the negative sign from the chain rule on e^(−4x) in the first product-rule term.' from version_ins
union all select gen_random_uuid(), id, 'B', '4e^(−4x) sin x', false, 'Multiplies the derivatives of the two factors, −4e^(−4x) and −sin x, instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '−e^(−4x)(4 cos x + sin x)', true, 'By the product rule with the chain rule on e^(−4x): −4e^(−4x) cos x + e^(−4x)(−sin x) = −e^(−4x)(4 cos x + sin x).' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^(−4x)(sin x − 4 cos x)', false, 'Uses +sin x as the derivative of cos x (sign error) in the second product-rule term.' from version_ins;
-- apcalcab-mcq-sv-005-v4
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-005-v4', 'mcq', 'Power Times a Sine of 3x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find d/dx [x² sin(3x)].', null, md5('apcalcab-mcq-sv-005-v4'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x sin(3x) + x² cos(3x)', false, 'Differentiates sin(3x) as cos(3x) and forgets the inner derivative factor 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '2x sin(3x) + 3x² cos(3x)', true, 'By the product rule with the chain rule on sin(3x): 2x sin(3x) + x²·3cos(3x) = 2x sin(3x) + 3x² cos(3x).' from version_ins
union all select gen_random_uuid(), id, 'C', '2x sin(3x) − 3x² cos(3x)', false, 'Uses −3cos(3x) as the derivative of sin(3x): keeps the inner factor 3 but gets the sign wrong.' from version_ins
union all select gen_random_uuid(), id, 'D', '6x cos(3x)', false, 'Multiplies the derivatives of the two factors, 2x and 3cos(3x), instead of applying the product rule.' from version_ins;
-- apcalcab-mcq-sv-005-v5
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-005-v5', 'mcq', 'Linear Factor Times a Gaussian Exponential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find d/dx [x e^(x²)].', null, md5('apcalcab-mcq-sv-005-v5'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x² e^(x²)', false, 'Keeps only the term x·2x e^(x²) and leaves out the term 1·e^(x²).' from version_ins
union all select gen_random_uuid(), id, 'B', 'e^(x²)(1 + 2x²)', true, 'By the product rule with the chain rule on e^(x²): 1·e^(x²) + x·2x e^(x²) = e^(x²)(1 + 2x²).' from version_ins
union all select gen_random_uuid(), id, 'C', '2x e^(x²)', false, 'Multiplies the derivatives of the two factors, 1 and 2x e^(x²), instead of applying the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^(x²)(1 + 2x)', false, 'Writes the derivative of e^(x²) as 2x e^(x²) but does not multiply it by the first factor x.' from version_ins;
-- apcalcab-mcq-sv-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-007-v3', 'mcq', 'Radical of a Quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find d/dx √(x² − 6x + 10).', null, md5('apcalcab-mcq-sv-007-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(x − 3)/√(x² − 6x + 10)', true, 'By the chain rule, the derivative is 1/(2√(x² − 6x + 10)) times the inner derivative 2x − 6, which simplifies to (x − 3)/√(x² − 6x + 10).' from version_ins
union all select gen_random_uuid(), id, 'B', '(2x − 6)√(x² − 6x + 10)', false, 'Multiplies the inner derivative 2x − 6 by √u instead of by the derivative of the square root, 1/(2√u).' from version_ins
union all select gen_random_uuid(), id, 'C', '(x − 3)/(2√(x² − 6x + 10))', false, 'Includes the factor 1/2 twice: once from the square root''s derivative and again after already simplifying (2x − 6)/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(2x − 6)/√(x² − 6x + 10)', false, 'Uses 1/√u instead of 1/(2√u) for the derivative of the square root, dropping the factor 1/2.' from version_ins;
-- apcalcab-mcq-sv-007-v4
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-007-v4', 'mcq', 'Reciprocal of a Radical', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find d/dx [1/√(2x + 5)].', null, md5('apcalcab-mcq-sv-007-v4'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/(2x + 5)^(3/2)', false, 'Loses the negative sign from the exponent −1/2 when applying the power rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/(2x + 5)^(3/2)', true, 'Write the function as (2x + 5)^(−1/2). By the chain rule, the derivative is (−1/2)(2x + 5)^(−3/2) times the inner derivative 2, which is −1/(2x + 5)^(3/2).' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/(2x + 5)^(1/2)', false, 'Does not reduce the exponent by 1: it differentiates (2x + 5)^(−1/2) to (−1/2)(2x + 5)^(−1/2)·2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/(2(2x + 5)^(3/2))', false, 'Applies the power rule but omits the inner derivative 2.' from version_ins;
commit;
