begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b2-h-3.4-a','apcalcab-mcq-b2-sv-h-3.4-a-v1','apcalcab-mcq-b2-sv-h-3.4-a-v2','apcalcab-mcq-b2-sv-h-3.4-a-v3','apcalcab-mcq-b2-h-3.4-b','apcalcab-mcq-b2-sv-h-3.4-b-v1','apcalcab-mcq-b2-sv-h-3.4-b-v2','apcalcab-mcq-b2-sv-h-3.4-b-v3','apcalcab-mcq-b2-h-3.5-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b2-h-3.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-h-3.4-a', 'mcq', 'differentiate sums of inverse trigonometric functions whose chain factors cancel or add.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, let f(x) = tan⁻¹(x) + tan⁻¹(1/x). What is f′(2)?', null, md5('apcalcab-mcq-b2-h-3.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', true, 'Correct: d/dx tan⁻¹(1/x) = [1/(1 + 1/x²)]·(−1/x²) = −1/(x² + 1), which cancels 1/(1 + x²), so f′(x) = 0 (f is constant, π/2, for x > 0).' from version_ins
union all select gen_random_uuid(), id, 'B', '2/5', false, 'This loses the minus sign from the chain factor −1/x² when differentiating tan⁻¹(1/x), so the two terms 1/5 and 1/5 are added.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'This omits the chain factor −1/x² on the second term, giving 1/(1 + 1/4) = 4/5 for it, and then 1/5 + 4/5 = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/5', false, 'This differentiates only the first term and treats tan⁻¹(1/x) as if it were constant.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.4-a-v1', 'mcq', 'differentiate sums of inverse trigonometric functions whose chain factors cancel or add. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, let g(x) = tan⁻¹(x) − tan⁻¹(1/x). What is g′(2)?', null, md5('apcalcab-mcq-b2-sv-h-3.4-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This assumes the expression is the constant identity tan⁻¹(x) + tan⁻¹(1/x), but the minus sign makes the two derivative terms add rather than cancel.' from version_ins
union all select gen_random_uuid(), id, 'B', '2/5', true, 'Correct: g′(x) = 1/(1 + x²) − [−1/(x² + 1)] = 2/(1 + x²), so g′(2) = 2/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3/5', false, 'This omits the chain factor −1/x² on the second term, giving 1/5 − 4/5 instead of 1/5 + 1/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/5', false, 'This keeps only the derivative of tan⁻¹(x) and drops the derivative of the second term entirely.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.4-a-v2', 'mcq', 'differentiate sums of inverse trigonometric functions whose chain factors cancel or add. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 3sin⁻¹(x) + 3cos⁻¹(x) + x² for −1 < x < 1. What is f′(1/2)?', null, md5('apcalcab-mcq-b2-sv-h-3.4-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4√3 + 1', false, 'This uses +1/√(1 − x²) for the derivative of cos⁻¹(x), so the two inverse trigonometric terms add instead of cancelling.' from version_ins
union all select gen_random_uuid(), id, 'B', '2√3 + 1', false, 'This keeps the derivative of 3sin⁻¹(x) and drops the derivative of 3cos⁻¹(x), so no cancellation occurs.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'This correctly cancels the two inverse trigonometric derivatives but drops the derivative 2x of x², which equals 1 at x = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', true, 'Correct: 3/√(1 − x²) − 3/√(1 − x²) = 0, so f′(x) = 2x and f′(1/2) = 1.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.4-a-v3', 'mcq', 'differentiate sums of inverse trigonometric functions whose chain factors cancel or add. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, let f(x) = tan⁻¹(2x) + tan⁻¹(1/(2x)). What is f′(1)?', null, md5('apcalcab-mcq-b2-sv-h-3.4-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/5', false, 'This takes the derivative of tan⁻¹(1/(2x)) with the wrong sign, so its term 2/5 is added to 2/5 instead of cancelling it.' from version_ins
union all select gen_random_uuid(), id, 'B', '2/5', false, 'This differentiates only tan⁻¹(2x), whose derivative at 1 is 2/5, and ignores the second term.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', true, 'Correct: f′(x) = 2/(1 + 4x²) + [1/(1 + 1/(4x²))]·(−1/(2x²)) = 2/(1 + 4x²) − 2/(4x² + 1) = 0; at x = 1 the terms are 2/5 and −2/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This applies the arctangent rule without the chain factors: 1/(1 + 4) + 1/(1 + 1/4) = 1/5 + 4/5.' from version_ins;
-- apcalcab-mcq-b2-h-3.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-h-3.4-b', 'mcq', 'apply an inverse trigonometric derivative to an unspecified inner function given only values of g and g′.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable function g satisfies g(2) = 3 and g′(2) = 10. Let h(x) = sin⁻¹(g(x)/5). What is h′(2)?', null, md5('apcalcab-mcq-b2-h-3.4-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '25/2', false, 'This forgets that the inner function is g(x)/5, so the factor 1/5 is missing from the chain-rule derivative of the argument.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5/2', false, 'This uses the derivative of cos⁻¹, which carries a minus sign, instead of the derivative of sin⁻¹.' from version_ins
union all select gen_random_uuid(), id, 'C', '25/8', false, 'This leaves out the square root: the sin⁻¹ derivative is 1/√(1 − u²), not 1/(1 − u²).' from version_ins
union all select gen_random_uuid(), id, 'D', '5/2', true, 'Correct: h′(2) = [g′(2)/5]/√(1 − (3/5)²) = 2/(4/5) = 5/2.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.4-b-v1', 'mcq', 'apply an inverse trigonometric derivative to an unspecified inner function given only values of g and g′. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable function g satisfies g(1) = 4 and g′(1) = −3. Let h(x) = tan⁻¹(g(x)/2). What is h′(1)?', null, md5('apcalcab-mcq-b2-sv-h-3.4-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3/10', true, 'Correct: h′(1) = [g′(1)/2]/(1 + (g(1)/2)²) = (−3/2)/(1 + 4) = −3/10.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/5', false, 'This omits the factor 1/2 from the derivative of g(x)/2, so g′(1) is used in place of g′(1)/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3/34', false, 'This puts g(1) = 4 instead of g(1)/2 = 2 into the denominator 1 + u², so the arctangent rule is evaluated at the wrong argument.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3/(2√5)', false, 'This uses 1/√(1 + u²) instead of 1/(1 + u²); the arctangent derivative has no square root.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.4-b-v2', 'mcq', 'apply an inverse trigonometric derivative to an unspecified inner function given only values of g and g′. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable function g satisfies g(3) = 2 and g′(3) = 6. Let h(x) = cos⁻¹(g(x)/4). What is h′(3)?', null, md5('apcalcab-mcq-b2-sv-h-3.4-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√3', false, 'This drops the minus sign from the derivative of cos⁻¹, which is −1/√(1 − u²).' from version_ins
union all select gen_random_uuid(), id, 'B', '−4√3', false, 'This omits the factor 1/4 from the derivative of g(x)/4, so g′(3) = 6 is used unscaled.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2', false, 'This leaves out the square root and uses −u′/(1 − u²) instead of −u′/√(1 − u²).' from version_ins
union all select gen_random_uuid(), id, 'D', '−√3', true, 'Correct: h′(3) = −[g′(3)/4]/√(1 − (2/4)²) = −(3/2)/(√3/2) = −√3.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.4-b-v3', 'mcq', 'apply an inverse trigonometric derivative to an unspecified inner function given only values of g and g′. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable function g satisfies g(1) = 3/4 and g′(1) = −2. Let h(x) = sin⁻¹(1 − g(x)). What is h′(1)?', null, md5('apcalcab-mcq-b2-sv-h-3.4-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−8/√15', false, 'This forgets that the derivative of 1 − g(x) is −g′(x), so the minus sign from the inner function is lost.' from version_ins
union all select gen_random_uuid(), id, 'B', '8/√15', true, 'Correct: h′(1) = −g′(1)/√(1 − (1 − g(1))²) = 2/√(1 − 1/16) = 2/(√15/4) = 8/√15.' from version_ins
union all select gen_random_uuid(), id, 'C', '32/15', false, 'This leaves out the square root, using 1/(1 − u²) in place of 1/√(1 − u²).' from version_ins
union all select gen_random_uuid(), id, 'D', '8/√7', false, 'This evaluates the square root at g(1) = 3/4 instead of at the argument 1 − g(1) = 1/4.' from version_ins;
-- apcalcab-mcq-b2-h-3.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-h-3.5-a', 'mcq', 'diagnose the first incorrect step in a worked derivative that mixes product, quotient and chain rules.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student differentiates h(x) = x²·sin(x³) as follows.
Step 1: By the product rule, h′(x) = (x²)′·sin(x³) + x²·(sin(x³))′.
Step 2: (x²)′ = 2x.
Step 3: (sin(x³))′ = cos(x³).
Step 4: Therefore h′(x) = 2x·sin(x³) + x²·cos(x³).
Which statement identifies the first incorrect step?', null, md5('apcalcab-mcq-b2-h-3.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Step 1 is incorrect: the product rule requires multiplying the derivatives of the two factors.', false, 'The product rule adds two terms, each differentiating one factor, so Step 1 is correct as written.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Step 3 is incorrect: the chain rule requires the factor 3x², so (sin(x³))′ = 3x²cos(x³).', true, 'Correct: The derivative of sin(x³) is cos(x³)·3x², so Step 3 is the first wrong step; the correct result is h′(x) = 2x sin(x³) + 3x⁴cos(x³).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Step 2 is incorrect: the derivative of x² is x.', false, 'The power rule gives (x²)′ = 2x, so Step 2 is correct.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Step 4 is incorrect: the two terms of the product rule should be multiplied, not added.', false, 'Step 4 correctly adds the two product-rule terms from Steps 1 to 3; its only flaw is inherited from Step 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b2-h-3.4-a','apcalcab-mcq-b2-sv-h-3.4-a-v1','apcalcab-mcq-b2-sv-h-3.4-a-v2','apcalcab-mcq-b2-sv-h-3.4-a-v3','apcalcab-mcq-b2-h-3.4-b','apcalcab-mcq-b2-sv-h-3.4-b-v1','apcalcab-mcq-b2-sv-h-3.4-b-v2','apcalcab-mcq-b2-sv-h-3.4-b-v3','apcalcab-mcq-b2-h-3.5-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b2-h-3.4-a','apcalcab-mcq-b2-sv-h-3.4-a-v1','apcalcab-mcq-b2-sv-h-3.4-a-v2','apcalcab-mcq-b2-sv-h-3.4-a-v3','apcalcab-mcq-b2-h-3.4-b','apcalcab-mcq-b2-sv-h-3.4-b-v1','apcalcab-mcq-b2-sv-h-3.4-b-v2','apcalcab-mcq-b2-sv-h-3.4-b-v3','apcalcab-mcq-b2-h-3.5-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
