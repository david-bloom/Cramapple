begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b2-sv-h-3.5-a-v1','apcalcab-mcq-b2-sv-h-3.5-a-v2','apcalcab-mcq-b2-sv-h-3.5-a-v3','apcalcab-mcq-b2-h-3.5-b','apcalcab-mcq-b2-sv-h-3.5-b-v1','apcalcab-mcq-b2-sv-h-3.5-b-v2','apcalcab-mcq-b2-sv-h-3.5-b-v3','apcalcab-mcq-b2-h-3.6-a','apcalcab-mcq-b2-sv-h-3.6-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b2-sv-h-3.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.5-a-v1', 'mcq', 'diagnose the first incorrect step in a worked derivative that mixes product, quotient and chain rules. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student differentiates g(x) = e²ˣ/(x² + 1) as follows.
Step 1: By the quotient rule, g′(x) = [(x² + 1)·(e²ˣ)′ − e²ˣ·(x² + 1)′]/(x² + 1).
Step 2: (e²ˣ)′ = 2e²ˣ.
Step 3: (x² + 1)′ = 2x.
Step 4: Therefore g′(x) = [2e²ˣ(x² + 1) − 2x·e²ˣ]/(x² + 1).
Which statement identifies the first incorrect step?', null, md5('apcalcab-mcq-b2-sv-h-3.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Step 2 is incorrect: the derivative of e²ˣ is e²ˣ.', false, 'The chain rule gives (e²ˣ)′ = 2e²ˣ, so Step 2 is correct.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Step 1 is incorrect: the denominator of the quotient rule must be (x² + 1)².', true, 'Correct: The quotient rule divides by the square of the denominator, so Step 1 is wrong; the correct result is g′(x) = e²ˣ(2x² − 2x + 2)/(x² + 1)².' from version_ins
union all select gen_random_uuid(), id, 'C', 'Step 3 is incorrect: the derivative of x² + 1 is x².', false, 'The derivative of x² + 1 is 2x, so Step 3 is correct.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Step 4 is incorrect: the numerator should add the two products rather than subtract them.', false, 'The quotient rule subtracts in the numerator, and Step 4 follows that pattern correctly from Steps 1 to 3.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.5-a-v2', 'mcq', 'diagnose the first incorrect step in a worked derivative that mixes product, quotient and chain rules. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student differentiates p(x) = x³(2x − 5)⁴ as follows.
Step 1: By the product rule, p′(x) = (x³)′·(2x − 5)⁴ + x³·((2x − 5)⁴)′.
Step 2: ((2x − 5)⁴)′ = 4(2x − 5)³.
Step 3: (x³)′ = 3x².
Step 4: Therefore p′(x) = 3x²(2x − 5)⁴ + 4x³(2x − 5)³.
Which statement identifies the first incorrect step?', null, md5('apcalcab-mcq-b2-sv-h-3.5-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Step 1 is incorrect: the product rule should multiply (x³)′ by ((2x − 5)⁴)′.', false, 'The product rule adds two terms; it never multiplies the two derivatives, so Step 1 is correct.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Step 3 is incorrect: the derivative of x³ is 3x.', false, 'The power rule gives (x³)′ = 3x², so Step 3 is correct.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Step 2 is incorrect: the chain rule requires the factor 2, so ((2x − 5)⁴)′ = 8(2x − 5)³.', true, 'Correct: The derivative of (2x − 5)⁴ is 4(2x − 5)³·2 = 8(2x − 5)³, so Step 2 is the first wrong step.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Step 4 is incorrect: the exponent 3 in the second term should be 4.', false, 'Step 4 only combines the earlier steps; the exponent 3 in the second term is correct, and the flaw lies earlier in Step 2.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.5-a-v3', 'mcq', 'diagnose the first incorrect step in a worked derivative that mixes product, quotient and chain rules. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student differentiates q(x) = x·cos(x²) as follows.
Step 1: By the product rule, q′(x) = (x)′·cos(x²) + x·(cos(x²))′.
Step 2: (x)′ = 1.
Step 3: (cos(x²))′ = −sin(x²)·2x.
Step 4: Therefore q′(x) = cos(x²) − 2x·sin(x²).
Which statement identifies the first incorrect step?', null, md5('apcalcab-mcq-b2-sv-h-3.5-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Step 3 is incorrect: the derivative of cos(x²) is +sin(x²)·2x.', false, 'The derivative of cos u is −sin u, so Step 3 correctly includes the minus sign and the factor 2x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Step 1 is incorrect: the product rule should differentiate only the second factor.', false, 'The product rule differentiates each factor in turn, so Step 1 is correct as written.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Step 2 is incorrect: the derivative of x is x.', false, 'The derivative of x is 1, so Step 2 is correct.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Step 4 is incorrect: the second term must also be multiplied by the factor x, giving −2x²sin(x²).', true, 'Correct: Steps 1 to 3 are right, but x·(−2x sin(x²)) = −2x² sin(x²), so Step 4 drops a factor of x; q′(x) = cos(x²) − 2x² sin(x²).' from version_ins;
-- apcalcab-mcq-b2-h-3.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-h-3.5-b', 'mcq', 'combine product, quotient and chain rules with tabulated values of unspecified functions, evaluating each derivative at ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
1 | 3 | −2 | 4 | 5
4 | −1 | 2 | 6 | 3
Let h(x) = x²·f(g(x)). What is h′(1)?', null, md5('apcalcab-mcq-b2-h-3.5-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', true, 'Correct: h′(x) = 2x·f(g(x)) + x²·f′(g(x))·g′(x). At x = 1: 2·f(4) + f′(4)·g′(1) = 2(−1) + 2·5 = 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '10', false, 'This drops the product-rule term 2x·f(g(x)) and keeps only x²·f′(g(x))·g′(x).' from version_ins
union all select gen_random_uuid(), id, 'C', '−12', false, 'This evaluates f′ at x = 1 instead of at g(1) = 4, so the outer derivative is taken at the wrong input.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This omits the inner derivative g′(1) in the chain rule for f(g(x)).' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.5-b-v1', 'mcq', 'combine product, quotient and chain rules with tabulated values of unspecified functions, evaluating each derivative at  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
1 | 2 | 3 | 6 | 1
2 | 0 | 1 | 5 | −4
Let h(x) = x³·g(f(x)). What is h′(1)?', null, md5('apcalcab-mcq-b2-sv-h-3.5-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12', false, 'This drops the product-rule term 3x²·g(f(x)) and keeps only the term containing g′(f(x))·f′(x).' from version_ins
union all select gen_random_uuid(), id, 'B', '18', false, 'This evaluates g′ at x = 1 instead of at f(1) = 2, so the outer derivative uses the wrong input.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'Correct: h′(x) = 3x²·g(f(x)) + x³·g′(f(x))·f′(x). At x = 1: 3·g(2) + g′(2)·f′(1) = 3·5 + (−4)·3 = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '11', false, 'This omits the inner derivative f′(1) in the chain rule for g(f(x)).' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.5-b-v2', 'mcq', 'combine product, quotient and chain rules with tabulated values of unspecified functions, evaluating each derivative at  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable function f has the values below.
x | f(x) | f′(x)
2 | 6 | −1
4 | 5 | 3
Let h(x) = f(x²)/x. What is h′(2)?', null, md5('apcalcab-mcq-b2-sv-h-3.5-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '19/4', true, 'Correct: h′(x) = [2x·f′(x²)·x − f(x²)]/x². At x = 2: (4·3·2 − 5)/4 = 19/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/4', false, 'This omits the inner derivative 2x when differentiating f(x²) in the numerator of the quotient rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '−7/2', false, 'This evaluates f and f′ at x = 2 instead of at x² = 4, so the table row used is wrong.' from version_ins
union all select gen_random_uuid(), id, 'D', '29/4', false, 'This adds f(x²) in the quotient-rule numerator, but the quotient rule subtracts numerator-derivative terms.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.5-b-v3', 'mcq', 'combine product, quotient and chain rules with tabulated values of unspecified functions, evaluating each derivative at  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
1 | 3 | 4 | −2 | 1
2 | 0 | 5 | 3 | −6
Let h(x) = f(x)·g(2x). What is h′(1)?', null, md5('apcalcab-mcq-b2-sv-h-3.5-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−24', true, 'Correct: h′(x) = f′(x)·g(2x) + f(x)·2g′(2x). At x = 1: 4·3 + 3·2·(−6) = −24.' from version_ins
union all select gen_random_uuid(), id, 'B', '−6', false, 'This omits the inner derivative 2 when differentiating g(2x), so g′(2) is not doubled.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2', false, 'This evaluates g and g′ at x = 1 instead of at 2x = 2, so the wrong table row is used.' from version_ins
union all select gen_random_uuid(), id, 'D', '−36', false, 'This drops the product-rule term f′(1)·g(2) and keeps only f(1)·2g′(2).' from version_ins;
-- apcalcab-mcq-b2-h-3.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-h-3.6-a', 'mcq', 'find a second derivative of a composite or product of unspecified functions by applying the chain and product rules twic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are twice differentiable, with g(1) = 2, g′(1) = 3, g″(1) = −4, f′(2) = 5 and f″(2) = −1. If h(x) = f(g(x)), what is h″(1)?', null, md5('apcalcab-mcq-b2-h-3.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−23', false, 'This forgets to square g′(1) in the term f″(g(x))·(g′(x))², using f″(2)·g′(1) = −3 instead of −9.' from version_ins
union all select gen_random_uuid(), id, 'B', '−29', true, 'Correct: h′(x) = f′(g(x))·g′(x); h″(x) = f″(g(x))·(g′(x))² + f′(g(x))·g″(x) = (−1)(9) + (5)(−4) = −29.' from version_ins
union all select gen_random_uuid(), id, 'C', '−9', false, 'This drops the product-rule term f′(g(x))·g″(x), which contributes 5·(−4) = −20.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This multiplies the two second derivatives, f″(2)·g″(1), which is not what differentiating twice produces.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.6-a-v1', 'mcq', 'find a second derivative of a composite or product of unspecified functions by applying the chain and product rules twic (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is twice differentiable, with f′(4) = 3 and f″(4) = −1/2. If h(x) = f(x²), what is h″(2)?', null, md5('apcalcab-mcq-b2-sv-h-3.6-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−8', false, 'This drops the term 2f′(x²) that comes from differentiating the factor 2x, keeping only 4x²·f″(x²).' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This omits the inner derivative 2x when differentiating f′(x²), using 2f′(4) + 2x·f″(4) instead of 2f′(4) + 4x²·f″(4).' from version_ins
union all select gen_random_uuid(), id, 'C', '−2', true, 'Correct: h′(x) = 2x·f′(x²); h″(x) = 2f′(x²) + 2x·2x·f″(x²) = 2·3 + 16·(−1/2) = −2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−14', false, 'This subtracts the product-rule term 2f′(x²) instead of adding it to 4x²·f″(x²).' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b2-sv-h-3.5-a-v1','apcalcab-mcq-b2-sv-h-3.5-a-v2','apcalcab-mcq-b2-sv-h-3.5-a-v3','apcalcab-mcq-b2-h-3.5-b','apcalcab-mcq-b2-sv-h-3.5-b-v1','apcalcab-mcq-b2-sv-h-3.5-b-v2','apcalcab-mcq-b2-sv-h-3.5-b-v3','apcalcab-mcq-b2-h-3.6-a','apcalcab-mcq-b2-sv-h-3.6-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b2-sv-h-3.5-a-v1','apcalcab-mcq-b2-sv-h-3.5-a-v2','apcalcab-mcq-b2-sv-h-3.5-a-v3','apcalcab-mcq-b2-h-3.5-b','apcalcab-mcq-b2-sv-h-3.5-b-v1','apcalcab-mcq-b2-sv-h-3.5-b-v2','apcalcab-mcq-b2-sv-h-3.5-b-v3','apcalcab-mcq-b2-h-3.6-a','apcalcab-mcq-b2-sv-h-3.6-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
