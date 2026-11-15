begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-h-3.5-b','apcalcbc-mcq-b2-sv-h-3.5-b-v1','apcalcbc-mcq-b2-sv-h-3.5-b-v2','apcalcbc-mcq-b2-sv-h-3.5-b-v3','apcalcbc-mcq-b2-h-3.6-a','apcalcbc-mcq-b2-sv-h-3.6-a-v1','apcalcbc-mcq-b2-sv-h-3.6-a-v2','apcalcbc-mcq-b2-sv-h-3.6-a-v3','apcalcbc-mcq-b2-h-3.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b2-h-3.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.5-b', 'mcq', 'combine product, quotient, power and chain rules with tabulated values of unspecified functions, evaluating each derivat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
2 | 2 | −1 | 1 | 2
4 | 0 | 5 | 6 | −3
Let h(x) = f(x)·g(x²)/x. What is h′(2)?', null, md5('apcalcbc-mcq-b2-h-3.5-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−9', false, 'This omits the chain-rule factor 2x when differentiating g(x²) in the numerator.' from version_ins
union all select gen_random_uuid(), id, 'B', '−12', false, 'This adds f(x)·g(x²) in the quotient-rule numerator, but the quotient rule subtracts numerator·denominator′.' from version_ins
union all select gen_random_uuid(), id, 'C', '−18', true, 'Correct: Let N(x) = f(x)·g(x²). N′ = f′(x)g(x²) + f(x)·2x·g′(x²). h′ = (N′·x − N)/x². At x = 2: N = 2·6 = 12, N′ = (−1)(6) + 2·4·(−3) = −30, so h′(2) = (−30·2 − 12)/4 = −18.' from version_ins
union all select gen_random_uuid(), id, 'D', '−15', false, 'This treats 1/x as a constant factor and differentiates only the product f(x)·g(x²), ignoring the derivative of 1/x.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.5-b-v1', 'mcq', 'combine product, quotient, power and chain rules with tabulated values of unspecified functions, evaluating each derivat (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
1 | 5 | 1 | 2 | 3
2 | 4 | −2 | 7 | 1
Let h(x) = g(x)/f(g(x)). What is h′(1)?', null, md5('apcalcbc-mcq-b2-sv-h-3.5-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/2', true, 'Correct: With D(x) = f(g(x)): D(1) = f(2) = 4 and D′(1) = f′(2)·g′(1) = −6. Then h′(1) = [g′(1)·D(1) − g(1)·D′(1)]/D(1)² = [12 + 12]/16 = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This omits the inner derivative g′(1) when differentiating f(g(x)) in the denominator.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/8', false, 'This evaluates f′ at x = 1 instead of at g(1) = 2, so the wrong table entry is used for f′.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This divides by f(g(x)) instead of by its square, forgetting that the quotient rule has denominator squared.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.5-b-v2', 'mcq', 'combine product, quotient, power and chain rules with tabulated values of unspecified functions, evaluating each derivat (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
2 | 1 | −2 | 5 | −1
4 | 0 | 3 | 3 | 2
Let h(x) = x·f(x)·g(x²). What is h′(2)?', null, md5('apcalcbc-mcq-b2-sv-h-3.5-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', true, 'Correct: Product rule on three factors: h′ = f·g(x²) + x·f′·g(x²) + x·f·2x·g′(x²). At x = 2: (1)(3) + 2(−2)(3) + 2(1)(4)(2) = 3 − 12 + 16 = 7.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5', false, 'This omits the chain-rule factor 2x when differentiating g(x²), so the last term is 2·1·2 instead of 2·1·4·2.' from version_ins
union all select gen_random_uuid(), id, 'C', '16', false, 'This keeps only the term in which g(x²) is differentiated and drops the other two product-rule terms.' from version_ins
union all select gen_random_uuid(), id, 'D', '−23', false, 'This evaluates g and g′ at x = 2 instead of at x² = 4, so the wrong table row is used.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.5-b-v3', 'mcq', 'combine product, quotient, power and chain rules with tabulated values of unspecified functions, evaluating each derivat (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
2 | 9 | 6 | 2 | −3
Let h(x) = g(x)·√(f(x)). What is h′(2)?', null, md5('apcalcbc-mcq-b2-sv-h-3.5-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−7', true, 'Correct: h′ = g′·√f + g·f′/(2√f). At x = 2: (−3)(3) + (2)(6)/(2·3) = −9 + 2 = −7.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5', false, 'This leaves out the factor 1/2 from the derivative of √f(x), using g·f′/√f instead of g·f′/(2√f).' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This drops the product-rule term g′(2)·√f(2) and keeps only g·f′/(2√f).' from version_ins
union all select gen_random_uuid(), id, 'D', '−26/3', false, 'This forgets the inner derivative f′(2) when differentiating √f(x), using g/(2√f) in place of g·f′/(2√f).' from version_ins;
-- apcalcbc-mcq-b2-h-3.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.6-a', 'mcq', 'find a second derivative of a reciprocal, root, logarithm or product of an unspecified function from its first and secon', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is twice differentiable, with f(1) = 2, f′(1) = 3 and f″(1) = −4. If h(x) = 1/f(x), what is h″(1)?', null, md5('apcalcbc-mcq-b2-h-3.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This keeps only −f″/f² and drops the term 2(f′)²/f³ that comes from differentiating 1/f² a second time.' from version_ins
union all select gen_random_uuid(), id, 'B', '13/4', true, 'Correct: h′ = −f′/f²; h″ = −f″/f² + 2(f′)²/f³. At x = 1: −(−4)/4 + 2(9)/8 = 1 + 9/4 = 13/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '5/4', false, 'This changes the sign of the first term, using f″/f² + 2(f′)²/f³ instead of −f″/f² + 2(f′)²/f³.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5/4', false, 'This subtracts the second term, using −f″/f² − 2(f′)²/f³; the chain-rule term 2(f′)²/f³ is positive.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.6-a-v1', 'mcq', 'find a second derivative of a reciprocal, root, logarithm or product of an unspecified function from its first and secon (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is twice differentiable and positive, with f(2) = 4, f′(2) = 2 and f″(2) = 1. If h(x) = √(f(x)), what is h″(2)?', null, md5('apcalcbc-mcq-b2-sv-h-3.6-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/8', true, 'Correct: h′ = f′/(2√f); h″ = f″/(2√f) − (f′)²/(4f^(3/2)). At x = 2: 1/4 − 4/32 = 1/4 − 1/8 = 1/8.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/4', false, 'This keeps only f″/(2√f) and drops the term −(f′)²/(4f^(3/2)) that comes from differentiating 1/√f.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/8', false, 'This adds the second term +(f′)²/(4f^(3/2)) instead of subtracting it; the derivative of f^(−1/2) carries a minus sign.' from version_ins
union all select gen_random_uuid(), id, 'D', '3/16', false, 'This uses f′ instead of (f′)² in the second term, forgetting the chain-rule factor f′ when differentiating f^(−1/2).' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.6-a-v2', 'mcq', 'find a second derivative of a reciprocal, root, logarithm or product of an unspecified function from its first and secon (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is twice differentiable and positive, with f(1) = 2, f′(1) = −3 and f″(1) = 5. If h(x) = ln(f(x)), what is h″(1)?', null, md5('apcalcbc-mcq-b2-sv-h-3.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/2', false, 'This keeps only f″/f and drops the term −(f′)²/f² from differentiating f′/f with the quotient rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '19/4', false, 'This adds (f′)² in the quotient-rule numerator, but the quotient rule subtracts f′·f′ from f″·f.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/4', true, 'Correct: h′ = f′/f; h″ = [f″·f − (f′)²]/f² = [5·2 − 9]/4 = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', false, 'This uses f″ − (f′)² in the numerator without the factor f, so the first quotient-rule term f″·f is wrong.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.6-a-v3', 'mcq', 'find a second derivative of a reciprocal, root, logarithm or product of an unspecified function from its first and secon (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is twice differentiable, with f(0) = 3, f′(0) = 1 and f″(0) = 4. If h(x) = f(x)·e^(−x), what is h″(0)?', null, md5('apcalcbc-mcq-b2-sv-h-3.6-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', true, 'Correct: h′ = e^(−x)(f′ − f); h″ = e^(−x)(f″ − f′) − e^(−x)(f′ − f) = e^(−x)(f″ − 2f′ + f). At x = 0: 4 − 2 + 3 = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '9', false, 'This uses e^(−x)(f″ + 2f′ + f), changing the sign of the middle term; each derivative of e^(−x) contributes a factor of −1.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'This uses f″ − f′ + f, forgetting the factor 2 on the middle term of the product rule applied twice.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This keeps only f″(0)·e⁰ and drops the terms from differentiating e^(−x).' from version_ins;
-- apcalcbc-mcq-b2-h-3.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.6-b', 'mcq', 'decide the concavity of a composite function from the signs of f′, f″, g′ and g″ using h″ = f″(g)(g′)² + f′(g)g″.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are twice differentiable on the real numbers. For all real t, f′(t) > 0 and f″(t) > 0, and for all real x, g′(x) < 0 and g″(x) > 0. Let h(x) = f(g(x)). Which statement about the graph of h is correct?', null, md5('apcalcbc-mcq-b2-h-3.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h is concave down on the real numbers, because g is decreasing.', false, 'This confuses a decreasing inner function with concave down; concavity depends on the sign of h″, which here is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The concavity of h cannot be determined, because g′ < 0 and f″ > 0 have opposite signs.', false, 'This drops the square: h″ contains f″(g(x))·(g′(x))², and the square makes that term positive despite g′ < 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h is concave up on the real numbers, because h″(x) is a sum of two positive terms.', true, 'Correct: h″(x) = f″(g(x))·(g′(x))² + f′(g(x))·g″(x). The first term is positive because f″ > 0 and the square is positive; the second is positive because f′ > 0 and g″ > 0. So h″ > 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h is concave down on the real numbers, because the composition reverses the concavity of f when g′ < 0.', false, 'This is not a valid rule; h″ = f″(g)(g′)² + f′(g)g″ is positive here, regardless of the sign of g′.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-h-3.5-b','apcalcbc-mcq-b2-sv-h-3.5-b-v1','apcalcbc-mcq-b2-sv-h-3.5-b-v2','apcalcbc-mcq-b2-sv-h-3.5-b-v3','apcalcbc-mcq-b2-h-3.6-a','apcalcbc-mcq-b2-sv-h-3.6-a-v1','apcalcbc-mcq-b2-sv-h-3.6-a-v2','apcalcbc-mcq-b2-sv-h-3.6-a-v3','apcalcbc-mcq-b2-h-3.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b2-h-3.5-b','apcalcbc-mcq-b2-sv-h-3.5-b-v1','apcalcbc-mcq-b2-sv-h-3.5-b-v2','apcalcbc-mcq-b2-sv-h-3.5-b-v3','apcalcbc-mcq-b2-h-3.6-a','apcalcbc-mcq-b2-sv-h-3.6-a-v1','apcalcbc-mcq-b2-sv-h-3.6-a-v2','apcalcbc-mcq-b2-sv-h-3.6-a-v3','apcalcbc-mcq-b2-h-3.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
