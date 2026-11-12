begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.8-b-v3','apcalcbc-mcq-b5-h-2.9-a','apcalcbc-mcq-b5-sv-h-2.9-a-v1','apcalcbc-mcq-b5-sv-h-2.9-a-v2','apcalcbc-mcq-b5-sv-h-2.9-a-v3','apcalcbc-mcq-b5-h-2.9-b','apcalcbc-mcq-b5-sv-h-2.9-b-v1','apcalcbc-mcq-b5-sv-h-2.9-b-v2','apcalcbc-mcq-b5-sv-h-2.9-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-sv-h-2.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.8-b-v3', 'mcq', 'locate horizontal tangent lines of a product by solving f′ = 0, separating critical points from zeros of f and from erro (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which values of x does the graph of f(x) = x²eˣ have a horizontal tangent line?', null, md5('apcalcbc-mcq-b5-sv-h-2.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = −2 only', false, 'This discards x = 0, but f′(x) = eˣ(x² + 2x) = x(x + 2)eˣ is also 0 at x = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 0 and x = 2', false, 'This factors x² + 2x as x(x − 2), a sign error, instead of x(x + 2).' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0 and x = −2', true, 'Correct: f′(x) = 2xeˣ + x²eˣ = x(x + 2)eˣ, which is 0 at x = 0 and x = −2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0 only', false, 'This multiplies the derivatives 2x and eˣ instead of using the product rule, which gives only x = 0.' from version_ins;
-- apcalcbc-mcq-b5-h-2.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.9-a', 'mcq', 'apply the quotient rule when the numerator or denominator is itself a sum or product involving values of f, g, f′, g′, t', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(2) = 3, f′(2) = −1, g(2) = 4, and g′(2) = 2. Let h(x) = f(x)/(x + g(x)). What is h′(2)?', null, md5('apcalcbc-mcq-b5-h-2.9-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/3', false, 'This differentiates the denominator as g′(2) = 2 instead of 1 + g′(2) = 3, leaving out the derivative of x.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/12', false, 'This subtracts in the wrong order, using (numerator)(derivative of denominator) minus (derivative of numerator)(denominator).' from version_ins
union all select gen_random_uuid(), id, 'C', '−5/12', true, 'Correct: h′ = (f′(x + g) − f(1 + g′))/(x + g)² = (−1·6 − 3·3)/36 = −15/36 = −5/12.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5/2', false, 'This leaves out the square of the denominator and divides by x + g(x) = 6 instead of by 36.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.9-a-v1', 'mcq', 'apply the quotient rule when the numerator or denominator is itself a sum or product involving values of f, g, f′, g′, t (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(1) = 3, f′(1) = −2, g(1) = 2, and g′(1) = 4. Let h(x) = (x² + f(x))/g(x). What is h′(1)?', null, md5('apcalcbc-mcq-b5-sv-h-2.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4', true, 'Correct: Numerator N = 1 + 3 = 4, N′ = 2 − 2 = 0, so h′ = (0·2 − 4·4)/2² = −16/4 = −4.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5', false, 'This differentiates the numerator as f′(1) = −2, leaving out the derivative 2x = 2 of x².' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This subtracts in the wrong order: (numerator)(g′) − (numerator′)(g).' from version_ins
union all select gen_random_uuid(), id, 'D', '−8', false, 'This leaves out the square of the denominator and divides by g(1) = 2 instead of by 4.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.9-a-v2', 'mcq', 'apply the quotient rule when the numerator or denominator is itself a sum or product involving values of f, g, f′, g′, t (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(3) = 2, f′(3) = 1, g(3) = 4, and g′(3) = −2. Let h(x) = x·f(x)/g(x). What is h′(3)?', null, md5('apcalcbc-mcq-b5-sv-h-2.9-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/4', false, 'This differentiates the numerator as f(3) alone, leaving out the term x f′ from the product rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This differentiates the numerator as f′(3) alone, treating x f(x) as if only f changed.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', true, 'Correct: N = x f = 6 and N′ = f + x f′ = 5, so h′ = (5·4 − 6·(−2))/16 = 32/16 = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This subtracts with the wrong sign, (20 − 12)/16, instead of 20 − (6)(−2) = 32 in the numerator.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.9-a-v3', 'mcq', 'apply the quotient rule when the numerator or denominator is itself a sum or product involving values of f, g, f′, g′, t (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(1) = 3, f′(1) = 5, g(1) = −4, and g′(1) = 3. Let h(x) = g(x)/(f(x) − x). What is h′(1)?', null, md5('apcalcbc-mcq-b5-sv-h-2.9-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13/2', false, 'This differentiates the denominator as f′(1) = 5, leaving out the derivative of x, which is 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5/2', false, 'This subtracts with the wrong sign, 6 − 16 instead of 6 + 16, mishandling g(−4) times the denominator derivative.' from version_ins
union all select gen_random_uuid(), id, 'C', '11/2', true, 'Correct: D = f − x = 2 and D′ = 5 − 1 = 4, so h′ = (g′D − gD′)/D² = (3·2 − (−4)(4))/4 = 22/4 = 11/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−11/2', false, 'This subtracts in the wrong order, (numerator)(derivative of denominator) − (derivative of numerator)(denominator).' from version_ins;
-- apcalcbc-mcq-b5-h-2.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.9-b', 'mcq', 'reverse the quotient rule: from a given tangent-slope condition on f/g (or g/f or xf/g) solve for an unknown derivative ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(a) = 6, g(a) = 3, and f′(a) = 4, with g(a) ≠ 0. The graph of h(x) = f(x)/g(x) has a horizontal tangent line at x = a. What is g′(a)?', null, md5('apcalcbc-mcq-b5-h-2.9-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', true, 'Correct: h′(a) = (f′g − fg′)/g² = 0 gives 4·3 − 6g′ = 0, so g′(a) = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This assumes f′(a) = g′(a), but a horizontal tangent for f/g requires f′g = fg′, not equal derivatives.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'This inverts the ratio, g′ = f′ f/g = 4·6/3, instead of f′ g/f = 4·3/6.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2', false, 'This sets the numerator f′g + fg′ equal to 0, a sign error, instead of f′g − fg′ = 0.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.9-b-v1', 'mcq', 'reverse the quotient rule: from a given tangent-slope condition on f/g (or g/f or xf/g) solve for an unknown derivative  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(a) = 2, g(a) = −2, and f′(a) = 5. The graph of h(x) = f(x)/g(x) has a tangent line of slope 3 at x = a. What is g′(a)?', null, md5('apcalcbc-mcq-b5-sv-h-2.9-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '11', false, 'This writes the numerator as f′g + fg′ with the wrong sign when solving, so it gets +11.' from version_ins
union all select gen_random_uuid(), id, 'B', '−11', true, 'Correct: (5(−2) − 2g′)/(−2)² = 3 gives −10 − 2g′ = 12, so g′(a) = −11.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2', false, 'This sets the numerator equal to 3g(a) = −6 instead of 3g(a)² = 12, dividing by g once instead of squaring it.' from version_ins
union all select gen_random_uuid(), id, 'D', '−13/2', false, 'This sets the numerator equal to 3 instead of 3g(a)² = 12, leaving out the square of the denominator.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.9-b-v2', 'mcq', 'reverse the quotient rule: from a given tangent-slope condition on f/g (or g/f or xf/g) solve for an unknown derivative  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(a) = 5, g(a) = −10, and g′(a) = −4. The graph of h(x) = g(x)/f(x) has a horizontal tangent line at x = a. What is f′(a)?', null, md5('apcalcbc-mcq-b5-sv-h-2.9-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4', false, 'This assumes f′(a) = g′(a), but a horizontal tangent for g/f requires g′f = gf′, not equal derivatives.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', true, 'Correct: h′(a) = (g′f − gf′)/f² = 0 gives (−4)(5) − (−10)f′ = 0, so f′(a) = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'This inverts the ratio, f′ = g′g/f = (−4)(−10)/5, instead of g′f/g = (−4)(5)/(−10).' from version_ins
union all select gen_random_uuid(), id, 'D', '−2', false, 'This sets g′f + gf′ = 0, a sign error, instead of g′f − gf′ = 0.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.9-b-v3', 'mcq', 'reverse the quotient rule: from a given tangent-slope condition on f/g (or g/f or xf/g) solve for an unknown derivative  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(2) = 3, g(2) = 6, and g′(2) = 4. The graph of h(x) = x f(x)/g(x) has a horizontal tangent line at x = 2. What is f′(2)?', null, md5('apcalcbc-mcq-b5-sv-h-2.9-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2', true, 'Correct: N = x f = 6, N′ = f + x f′ = 3 + 2f′; h′ = 0 gives N′g = N g′, so (3 + 2f′)6 = 6·4 and f′(2) = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This treats the numerator derivative as f′(2) alone, so it solves f′·g = (x f)·g′ and ignores the term f from the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This treats the numerator derivative as x f′ alone, leaving out the term f(2) = 3 from the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '−7/2', false, 'This sets the numerator equal to −(x f)g′, a sign error that turns 3 + 2f′ = 4 into 3 + 2f′ = −4.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.8-b-v3','apcalcbc-mcq-b5-h-2.9-a','apcalcbc-mcq-b5-sv-h-2.9-a-v1','apcalcbc-mcq-b5-sv-h-2.9-a-v2','apcalcbc-mcq-b5-sv-h-2.9-a-v3','apcalcbc-mcq-b5-h-2.9-b','apcalcbc-mcq-b5-sv-h-2.9-b-v1','apcalcbc-mcq-b5-sv-h-2.9-b-v2','apcalcbc-mcq-b5-sv-h-2.9-b-v3']) and status='draft')<>9 then raise exception 'chunk 8: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-sv-h-2.8-b-v3','apcalcbc-mcq-b5-h-2.9-a','apcalcbc-mcq-b5-sv-h-2.9-a-v1','apcalcbc-mcq-b5-sv-h-2.9-a-v2','apcalcbc-mcq-b5-sv-h-2.9-a-v3','apcalcbc-mcq-b5-h-2.9-b','apcalcbc-mcq-b5-sv-h-2.9-b-v1','apcalcbc-mcq-b5-sv-h-2.9-b-v2','apcalcbc-mcq-b5-sv-h-2.9-b-v3']))<>36 then raise exception 'chunk 8: expected 36 choices'; end if;
end $$;
commit;
