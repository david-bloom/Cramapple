begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-sv-007-v5','apcalcab-mcq-sv-008-v3','apcalcab-mcq-sv-008-v4','apcalcab-mcq-sv-008-v5','apcalcab-mcq-sv-030-v3','apcalcab-mcq-sv-030-v4','apcalcab-mcq-sv-030-v5','apcalcab-mcq-sv-029-v3','apcalcab-mcq-sv-029-v4','apcalcab-mcq-sv-029-v5'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-sv-007-v5
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-007-v5', 'mcq', 'Power of a Quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Find d/dx (x² + 1)⁵.', null, md5('apcalcab-mcq-sv-007-v5'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10x(x² + 1)⁵', false, 'Multiplies by the inner derivative 2x and the exponent 5 but does not reduce the exponent from 5 to 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '5x(x² + 1)⁴', false, 'Takes the derivative of the inner function x² + 1 to be x instead of 2x.' from version_ins
union all select gen_random_uuid(), id, 'C', '10x(x² + 1)⁴', true, 'By the chain rule, the derivative is 5(x² + 1)⁴ times the inner derivative 2x, which is 10x(x² + 1)⁴.' from version_ins
union all select gen_random_uuid(), id, 'D', '5(x² + 1)⁴', false, 'Applies the power rule to the outer function but omits the inner derivative 2x.' from version_ins;
-- apcalcab-mcq-sv-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-008-v3', 'mcq', 'Slope on a Cubic Curve', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the curve x³ + y³ = 9, what is dy/dx at the point (1, 2)?', null, md5('apcalcab-mcq-sv-008-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4', false, 'Inverts the ratio: uses −y²/x² instead of −x²/y².' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/2', false, 'Differentiates y³ as 3y·y′ instead of 3y²·y′, giving y′ = −x²/y, which is −1/2 at (1, 2).' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/4', true, 'Implicit differentiation gives 3x² + 3y²·y′ = 0, so y′ = −x²/y². At (1, 2) this is −1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/4', false, 'Loses the negative sign when solving 3x² + 3y² y′ = 0 for y′.' from version_ins;
-- apcalcab-mcq-sv-008-v4
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-008-v4', 'mcq', 'Slope on a Curve With an xy Term', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the curve xy + y² = 8, what is dy/dx at the point (2, 2)?', null, md5('apcalcab-mcq-sv-008-v4'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/3', true, 'Implicit differentiation with the product rule gives y + x·y′ + 2y·y′ = 0, so y′ = −y/(x + 2y). At (2, 2) this is −2/(2 + 4) = −1/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/3', false, 'Loses the negative sign when solving y + x y′ + 2y y′ = 0 for y′.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3', false, 'Inverts the ratio, using −(x + 2y)/y instead of −y/(x + 2y).' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/2', false, 'Differentiates y² as y·y′ instead of 2y·y′, so the denominator is 2 + 2 = 4 instead of 2 + 4 = 6.' from version_ins;
-- apcalcab-mcq-sv-008-v5
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-008-v5', 'mcq', 'Slope on a Curve With x²y', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the curve x²y + y³ = 10, what is dy/dx at the point (1, 2)?', null, md5('apcalcab-mcq-sv-008-v5'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/13', false, 'Loses the negative sign when solving 2xy + x² y′ + 3y² y′ = 0 for y′.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4/13', true, 'Implicit differentiation with the product rule gives 2xy + x²·y′ + 3y²·y′ = 0, so y′ = −2xy/(x² + 3y²). At (1, 2) this is −4/(1 + 12) = −4/13.' from version_ins
union all select gen_random_uuid(), id, 'C', '−13/4', false, 'Inverts the ratio, using −(x² + 3y²)/(2xy) instead of −2xy/(x² + 3y²).' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/3', false, 'Treats y as a constant in x²y, so the term is 2xy with no y′ part: 2xy + 3y² y′ = 0 gives y′ = −4/12 = −1/3.' from version_ins;
-- apcalcab-mcq-sv-030-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-030-v3', 'mcq', 'Slope on a Circle at (5, 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the curve x² + y² = 34, what is dy/dx at the point (5, 3)?', null, md5('apcalcab-mcq-sv-030-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−5/3', true, 'Differentiating implicitly gives 2x + 2y·y′ = 0, so y′ = −x/y. At (5, 3) this is −5/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/5', false, 'Inverts the ratio and loses the negative sign.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3/5', false, 'Inverts the ratio, using −y/x instead of −x/y.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/3', false, 'Loses the negative sign when solving 2x + 2y y′ = 0 for y′.' from version_ins;
-- apcalcab-mcq-sv-030-v4
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-030-v4', 'mcq', 'Slope on a Shifted Circle', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the curve (x − 1)² + (y + 2)² = 25, what is dy/dx at the point (4, 2)?', null, md5('apcalcab-mcq-sv-030-v4'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4/3', false, 'Inverts the ratio, using −(y + 2)/(x − 1) instead of −(x − 1)/(y + 2).' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/2', false, 'Uses y instead of y + 2 in the denominator: −(x − 1)/y = −3/2 at (4, 2).' from version_ins
union all select gen_random_uuid(), id, 'C', '−3/4', true, 'Differentiating implicitly gives 2(x − 1) + 2(y + 2)·y′ = 0, so y′ = −(x − 1)/(y + 2). At (4, 2) this is −3/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '3/4', false, 'Loses the negative sign when solving 2(x − 1) + 2(y + 2) y′ = 0 for y′.' from version_ins;
-- apcalcab-mcq-sv-030-v5
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-030-v5', 'mcq', 'Slope on an Ellipse', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the curve 4x² + y² = 20, what is dy/dx at the point (2, 2)?', null, md5('apcalcab-mcq-sv-030-v5'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/4', false, 'Inverts the ratio, using −y/(4x) instead of −4x/y.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4', true, 'Differentiating implicitly gives 8x + 2y·y′ = 0, so y′ = −4x/y. At (2, 2) this is −4.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'Loses the negative sign when solving 8x + 2y y′ = 0 for y′.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', false, 'Ignores the coefficient 4: uses −x/y, which is −1 at (2, 2).' from version_ins;
-- apcalcab-mcq-sv-029-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-029-v3', 'mcq', 'Derivative of a Cosine of a Quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = cos(3x²), what is f′(x)?', null, md5('apcalcab-mcq-sv-029-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6x sin(3x²)', false, 'Uses +sin as the derivative of cos (sign error).' from version_ins
union all select gen_random_uuid(), id, 'B', '−sin(6x)', false, 'Differentiates the inner function inside the sine, 3x² to 6x, instead of multiplying by it.' from version_ins
union all select gen_random_uuid(), id, 'C', '−6x sin(3x²)', true, 'By the chain rule, f′(x) = −sin(3x²) times the inner derivative 6x, which is −6x sin(3x²).' from version_ins
union all select gen_random_uuid(), id, 'D', '−sin(3x²)', false, 'Omits the inner derivative 6x.' from version_ins;
-- apcalcab-mcq-sv-029-v4
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-029-v4', 'mcq', 'Derivative of an Exponential of a Sine', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = e^(sin x), what is f′(x)?', null, md5('apcalcab-mcq-sv-029-v4'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'cos x · e^(sin x)', true, 'By the chain rule, f′(x) = e^(sin x) times the inner derivative cos x, which is cos x · e^(sin x).' from version_ins
union all select gen_random_uuid(), id, 'B', 'e^(cos x)', false, 'Differentiates the exponent inside the exponential, changing sin x to cos x, instead of multiplying by it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin x · e^(sin x − 1)', false, 'Applies the power rule to e^(sin x) as if e were the variable base.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^(sin x)', false, 'Omits the inner derivative cos x.' from version_ins;
-- apcalcab-mcq-sv-029-v5
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-029-v5', 'mcq', 'Derivative of a Natural Log of a Quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = ln(x² + 4), what is f′(x)?', null, md5('apcalcab-mcq-sv-029-v5'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x ln(x² + 4)', false, 'Multiplies the inner derivative 2x by ln(x² + 4) instead of by 1/(x² + 4).' from version_ins
union all select gen_random_uuid(), id, 'B', 'ln(2x)', false, 'Replaces the argument by its derivative inside the logarithm instead of using the rule for the derivative of ln.' from version_ins
union all select gen_random_uuid(), id, 'C', '2x/(x² + 4)', true, 'By the chain rule, f′(x) = (1/(x² + 4)) times the inner derivative 2x, which is 2x/(x² + 4).' from version_ins
union all select gen_random_uuid(), id, 'D', '1/(x² + 4)', false, 'Omits the inner derivative 2x.' from version_ins;
commit;
