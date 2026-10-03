begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u2n-003-v3','apcalcab-mcq-u2n-004-v1','apcalcab-mcq-u2n-004-v2','apcalcab-mcq-u2n-004-v3','apcalcab-mcq-u2n-005-v1','apcalcab-mcq-u2n-005-v2','apcalcab-mcq-u2n-005-v3','apcalcab-mcq-u2n-006-v1','apcalcab-mcq-u2n-006-v2','apcalcab-mcq-u2n-006-v3','apcalcab-mcq-u2n-007-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u2n-003-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-003-v3', 'mcq', 'Limit definition with sin x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The limit lim(h→0) [sin(π/6 + h) − 1/2] / h equals f′(π/6) for f(x) = sin x. What is the value of this limit?', null, md5('apcalcab-mcq-u2n-003-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√3/2', true, 'The quotient is [f(π/6 + h) − f(π/6)]/h with f(x) = sin x, so the limit is f′(π/6) = cos(π/6) = √3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2', false, '1/2 is sin(π/6), which comes from using (sin x)′ = sin x. The derivative of sin x is cos x, so f′(π/6) = √3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−√3/2', false, '−√3/2 uses (sin x)′ = −cos x. The derivative of sin x is cos x, so f′(π/6) = cos(π/6) = √3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Substituting h = 0 gives sin(π/6) − 1/2 = 0 over 0, which is 0/0 and indeterminate, not 0. The limit is f′(π/6) = √3/2.' from version_ins;
-- apcalcab-mcq-u2n-004-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-004-v1', 'mcq', 'Table estimate at x = 8', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has the tabulated values below.

x:    2    5    6    10
f(x): 4   13   19    33

Approximate f′(8) with a difference quotient built from the nearest listed x-values that lie on either side of 8.', null, md5('apcalcab-mcq-u2n-004-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7/2', true, 'The closest table values on either side of x = 8 are x = 6 and x = 10, so f′(8) ≈ (f(10) − f(6))/(10 − 6) = (33 − 19)/4 = 14/4 = 7/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, '6 is the slope over [5, 6], (19 − 13)/(6 − 5) = 6. That interval does not contain x = 8; the closest points on either side are x = 6 and x = 10, giving 7/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '14', false, '14 is the change f(10) − f(6) = 33 − 19 = 14, which was not divided by 10 − 6 = 4; the estimate is 14/4 = 7/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '7/8', false, '7/8 divides f(10) − f(6) = 14 by 10 + 6 = 16. The change in x is 10 − 6 = 4, so the estimate is 14/4 = 7/2.' from version_ins;
-- apcalcab-mcq-u2n-004-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-004-v2', 'mcq', 'Cooling rate from a table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature T(t), in °C, of a cup of coffee is recorded at selected times t minutes.

t:    0    10   20   40
T(t): 80   62   50   35

Using the two table values closest to t = 30 on either side, what is the best estimate of T′(30)?', null, md5('apcalcab-mcq-u2n-004-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3/4 °C per minute', true, 'The closest times on either side of t = 30 are t = 20 and t = 40, so T′(30) ≈ (T(40) − T(20))/(40 − 20) = (35 − 50)/20 = −15/20 = −3/4 °C per minute.' from version_ins
union all select gen_random_uuid(), id, 'B', '−15 °C per minute', false, '−15 is the change T(40) − T(20) = 35 − 50 = −15, which was not divided by 40 − 20 = 20; the estimate is −15/20 = −3/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/4 °C per minute', false, '−1/4 divides T(40) − T(20) = −15 by 40 + 20 = 60. The change in t is 40 − 20 = 20, so the estimate is −15/20 = −3/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '−6/5 °C per minute', false, '−6/5 is the slope over [10, 20], (50 − 62)/(20 − 10) = −12/10 = −6/5. That interval does not contain t = 30; the closest times on either side are 20 and 40, giving −3/4.' from version_ins;
-- apcalcab-mcq-u2n-004-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-004-v3', 'mcq', 'Acceleration from velocity table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Selected values of the velocity v(t), in m/s, of a particle at time t seconds are given.

t:    0   1    4    7
v(t): 5   1   −8   −20

Using the two table values closest to t = 3 on either side, what is the best estimate of the acceleration v′(3)?', null, md5('apcalcab-mcq-u2n-004-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−9/5 m/s²', false, '−9/5 divides v(4) − v(1) = −9 by 4 + 1 = 5. The change in t is 4 − 1 = 3, so the estimate is −9/3 = −3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3 m/s²', true, 'The closest times on either side of t = 3 are t = 1 and t = 4, so v′(3) ≈ (v(4) − v(1))/(4 − 1) = (−8 − 1)/3 = −3 m/s².' from version_ins
union all select gen_random_uuid(), id, 'C', '−4 m/s²', false, '−4 is the slope over [4, 7], (−20 − (−8))/(7 − 4) = −12/3 = −4. That interval does not contain t = 3; the closest times on either side are 1 and 4, giving −3.' from version_ins
union all select gen_random_uuid(), id, 'D', '−9 m/s²', false, '−9 is the change v(4) − v(1) = −8 − 1 = −9, which was not divided by 4 − 1 = 3; the estimate is −9/3 = −3.' from version_ins;
-- apcalcab-mcq-u2n-005-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-005-v1', 'mcq', 'Equal slopes but a jump', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = x² for x ≤ 1, and g(x) = 2x + 1 for x > 1. Which statement about g at x = 1 is true?', null, md5('apcalcab-mcq-u2n-005-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is continuous at x = 1 because the one-sided slopes are equal.', false, 'Continuity depends on function values, not slopes. The left piece gives 1 and the right piece approaches 3, so the limit does not exist and g is not continuous at 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is not differentiable at x = 1 because g is not continuous there.', true, 'The left piece gives g(1) = 1 and the right piece approaches 2(1) + 1 = 3, so the limit does not exist and g is discontinuous at 1. A function that is not continuous at a point cannot be differentiable there, even though both pieces have slope 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is continuous at x = 1 but not differentiable there because the two formulas differ.', false, 'The formulas differing does not by itself make the function continuous. Since the left value is 1 and the right limit is 3, g is not continuous at 1 (the formulas also have equal slopes there).' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is differentiable at x = 1 because both pieces have slope 2 there.', false, 'Both pieces do have slope 2 at x = 1 (2x = 2 and the line has slope 2), but differentiability also requires continuity. The values 1 and 3 do not match, so g is discontinuous and not differentiable at 1.' from version_ins;
-- apcalcab-mcq-u2n-005-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-005-v2', 'mcq', 'Smooth join of two pieces', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x² for x ≤ 1, and f(x) = 2x − 1 for x > 1. Which statement about f at x = 1 is true?', null, md5('apcalcab-mcq-u2n-005-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is both continuous and differentiable at x = 1.', true, 'Both pieces equal 1 at x = 1 (1² = 1 and 2(1) − 1 = 1), so f is continuous. The left derivative is 2x = 2 and the right derivative is 2, so f′(1) = 2 exists.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is continuous at x = 1 but not differentiable there because the formulas differ.', false, 'Different formulas do not prevent differentiability. The left derivative is 2(1) = 2 and the right derivative is 2, so the one-sided derivatives agree and f′(1) = 2 exists.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is differentiable at x = 1 but not continuous there.', false, 'Differentiability at a point requires continuity there, so this combination is impossible. In fact both pieces equal 1 at x = 1, so f is continuous (and differentiable) at 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is not continuous at x = 1 because f is defined by two pieces.', false, 'Being defined piecewise does not make a function discontinuous. Both pieces equal 1 at x = 1, so the limit exists and equals f(1) = 1; f is continuous at 1.' from version_ins;
-- apcalcab-mcq-u2n-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-005-v3', 'mcq', 'Cusp of a two-thirds power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let q(x) = x^(2/3) for all real x. Which statement about q at x = 0 is true?', null, md5('apcalcab-mcq-u2n-005-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'q is differentiable at x = 0 because q is continuous there.', false, 'q is continuous at 0, but continuity does not imply differentiability. q′(x) = (2/3)x^(−1/3) is unbounded near 0, so q′(0) does not exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'q is continuous at x = 0 but not differentiable there.', true, 'q(0) = 0 and q(x) → 0 as x → 0, so q is continuous at 0. But q′(x) = (2/3)x^(−1/3) is unbounded near 0 (it approaches −∞ from the left and +∞ from the right), so q′(0) does not exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'q is differentiable at x = 0 with q′(0) = 0 because q has a minimum there.', false, 'q does have a minimum at 0, but a minimum gives a horizontal tangent only if the derivative exists. Here q′(x) = (2/3)x^(−1/3) is unbounded near 0, so the graph has a cusp and q′(0) does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'q is not continuous at x = 0 because q′(0) does not exist.', false, 'Continuity depends on the function values, not on the derivative. The limit of x^(2/3) as x → 0 is 0 = q(0), so q is continuous at 0; the nonexistent derivative only shows q is not differentiable.' from version_ins;
-- apcalcab-mcq-u2n-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-006-v1', 'mcq', 'Power rule on 5/x³', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = 5/x³, then f′(x) = ?', null, md5('apcalcab-mcq-u2n-006-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15/x⁴', false, 'This loses the negative sign from the exponent −3. The power rule gives 5(−3)x⁻⁴ = −15/x⁴.' from version_ins
union all select gen_random_uuid(), id, 'B', '−15/x⁴', true, 'Rewrite f(x) = 5x⁻³. Then f′(x) = 5(−3)x⁻⁴ = −15x⁻⁴ = −15/x⁴.' from version_ins
union all select gen_random_uuid(), id, 'C', '−15/x²', false, 'This adds 1 to the exponent (−3 + 1 = −2) instead of subtracting 1. The new exponent is −4, so f′(x) = −15/x⁴.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5/x⁴', false, 'This gets the new exponent −4 right but keeps the coefficient 5 (with a negative sign) instead of multiplying 5 by the exponent −3. The power rule gives 5(−3)x⁻⁴ = −15/x⁴.' from version_ins;
-- apcalcab-mcq-u2n-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-006-v2', 'mcq', 'Power rule on 4 over root x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, what is the derivative of f(x) = 4/√x?', null, md5('apcalcab-mcq-u2n-006-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2√x', false, 'This adds 1 to the exponent (−1/2 + 1 = 1/2) instead of subtracting 1, giving 4(−1/2)x^(1/2) = −2√x. Subtracting 1 gives the exponent −3/2, so f′(x) = −2/x^(3/2).' from version_ins
union all select gen_random_uuid(), id, 'B', '−4/x^(3/2)', false, 'This gets the exponent −3/2 right but multiplies by −1 instead of by the exponent −1/2, giving 4(−1)x^(−3/2) = −4/x^(3/2). The power rule multiplies by the exponent: 4(−1/2) = −2, so f′(x) = −2/x^(3/2).' from version_ins
union all select gen_random_uuid(), id, 'C', '−2/x^(3/2)', true, 'Rewrite f(x) = 4x^(−1/2). Then f′(x) = 4(−1/2)x^(−3/2) = −2x^(−3/2) = −2/x^(3/2).' from version_ins
union all select gen_random_uuid(), id, 'D', '2/x^(3/2)', false, 'This loses the negative sign from the exponent −1/2. The power rule gives 4(−1/2)x^(−3/2) = −2/x^(3/2).' from version_ins;
-- apcalcab-mcq-u2n-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-006-v3', 'mcq', 'Power rule on a scaled reciprocal', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = 1/(2x⁴) for x ≠ 0. Which expression gives h′(x)?', null, md5('apcalcab-mcq-u2n-006-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/(2x⁵)', false, 'This gets the new exponent −5 right but keeps the coefficient 1/2 (with a negative sign) instead of multiplying 1/2 by the exponent −4. The power rule gives (1/2)(−4)x⁻⁵ = −2/x⁵.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2/x³', false, 'This adds 1 to the exponent (−4 + 1 = −3) instead of subtracting 1, giving (1/2)(−4)x⁻³ = −2/x³. The new exponent is −5, so h′(x) = −2/x⁵.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2/x⁵', true, 'Rewrite h(x) = (1/2)x⁻⁴. Then h′(x) = (1/2)(−4)x⁻⁵ = −2x⁻⁵ = −2/x⁵.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/x⁵', false, 'This loses the negative sign from the exponent −4. The power rule gives (1/2)(−4)x⁻⁵ = −2/x⁵.' from version_ins;
-- apcalcab-mcq-u2n-007-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-007-v1', 'mcq', 'Horizontal tangent of 2x^(3/2) − 30x^(1/2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, let f(x) = 2x^(3/2) − 30x^(1/2). At what value of x does the graph of f have a horizontal tangent line?', null, md5('apcalcab-mcq-u2n-007-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 15', false, 'This solves f(x) = 0 (2x^(3/2) = 30x^(1/2) gives x = 15) rather than f′(x) = 0. A horizontal tangent requires f′(x) = 0, which gives x = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 5', true, 'f′(x) = 3x^(1/2) − 15x^(−1/2). Setting this to 0: 3√x = 15/√x, so 3x = 15 and x = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 10', false, 'This uses the derivative of 30x^(1/2) as 30x^(−1/2) (missing the factor 1/2). Then 3√x = 30/√x gives x = 10, but the correct term is 15x^(−1/2), which gives x = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 15/2', false, 'This differentiates 2x^(3/2) as 2x^(1/2) (missing the factor 3/2). Then 2√x = 15/√x gives x = 15/2, but the correct first term is 3x^(1/2), which gives x = 5.' from version_ins;
commit;
