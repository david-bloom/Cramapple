begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.7-b-v2','apcalcbc-mcq-b5-sv-h-2.7-b-v3','apcalcbc-mcq-b5-h-2.8-a','apcalcbc-mcq-b5-sv-h-2.8-a-v1','apcalcbc-mcq-b5-sv-h-2.8-a-v2','apcalcbc-mcq-b5-sv-h-2.8-a-v3','apcalcbc-mcq-b5-h-2.8-b','apcalcbc-mcq-b5-sv-h-2.8-b-v1','apcalcbc-mcq-b5-sv-h-2.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-sv-h-2.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.7-b-v2', 'mcq', 'evaluate a high-order derivative of sin x, cos x, and eˣ by identifying the cycle of length four and the remainder of th (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 2cos x + 5eˣ. What is the 102nd derivative of f at x = 0?', null, md5('apcalcbc-mcq-b5-sv-h-2.7-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', false, 'This treats 102 as a multiple of 4, where 2cos x returns to itself with value 2, but 102 leaves remainder 2 and gives −2cos x.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', true, 'Correct: 102 = 4·25 + 2, so the cosine term gives −2cos x, and 5eˣ stays 5eˣ; at 0 the value is −2 + 5 = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This drops the contribution of the cosine term, as happens at an odd order, but 102 is even and gives −2cos 0 = −2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2', false, 'This differentiates the cosine term correctly but treats 5eˣ as vanishing, when every derivative of eˣ is eˣ and contributes 5e⁰ = 5.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.7-b-v3', 'mcq', 'evaluate a high-order derivative of sin x, cos x, and eˣ by identifying the cycle of length four and the remainder of th (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 2 sin x − cos x. What is the 7th derivative of f at x = π?', null, md5('apcalcbc-mcq-b5-sv-h-2.7-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2', false, 'This uses the first derivative of f, 2cos x + sin x, whose value at π is −2, but 7 = 4 + 3 requires the third derivative.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This treats 7 as a multiple of 4, where f returns to itself with value 2 sin π − cos π = 1, but 7 leaves remainder 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This uses the second derivative of f, −2 sin x + cos x, whose value at π is −1, but 7 leaves remainder 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', true, 'Correct: 7 = 4 + 3, so f^(7) is the third derivative: (2 sin x)‴ = −2cos x and (−cos x)‴ = −sin x; at π this is 2 − 0 = 2.' from version_ins;
-- apcalcbc-mcq-b5-h-2.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.8-a', 'mcq', 'differentiate a product of three factors, one given only by table values, tracking every term of the product rule.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(2) = 3, f′(2) = −1, g(2) = 2, and g′(2) = 4. Let h(x) = x·f(x)·g(x). What is h′(2)?', null, md5('apcalcbc-mcq-b5-h-2.8-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '26', true, 'Correct: h′ = f g + x f′ g + x f g′ = 6 + 2(−1)(2) + 2(3)(4) = 6 − 4 + 24 = 26.' from version_ins
union all select gen_random_uuid(), id, 'B', '20', false, 'This leaves out the term from differentiating the factor x, which contributes f(2)g(2) = 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '−4', false, 'This multiplies the three derivatives, 1·(−1)·4, instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '16', false, 'This keeps all three terms but drops the multiplying factor x = 2 from the two terms that keep x: 6 − 2 + 12.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.8-a-v1', 'mcq', 'differentiate a product of three factors, one given only by table values, tracking every term of the product rule. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(ln 2) = 2, f′(ln 2) = 3, g(ln 2) = −1, and g′(ln 2) = 5. Let h(x) = eˣ·f(x)·g(x). What is h′(ln 2)?', null, md5('apcalcbc-mcq-b5-sv-h-2.8-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '14', false, 'This leaves out the term from differentiating eˣ, which contributes eˣf g, so only the terms with f′ and g′ remain.' from version_ins
union all select gen_random_uuid(), id, 'B', '30', false, 'This multiplies the three derivatives, e^(ln 2)·3·5, instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '12', false, 'This treats the derivative of eˣ as 1 instead of eˣ, so the first term is f g = −2 rather than eˣ f g = −4.' from version_ins
union all select gen_random_uuid(), id, 'D', '10', true, 'Correct: h′ = eˣ(f g + f′g + f g′) = 2(−2 − 3 + 10) = 10 at x = ln 2.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.8-a-v2', 'mcq', 'differentiate a product of three factors, one given only by table values, tracking every term of the product rule. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(1) = 4, f′(1) = 2, g(1) = 3, and g′(1) = −2. Let h(x) = (f(x) + x)(g(x) − x²). What is h′(1)?', null, md5('apcalcbc-mcq-b5-sv-h-2.8-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12', false, 'This multiplies the derivatives of the two factors, (f′ + 1)(g′ − 2x) = 3·(−4), instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '−14', true, 'Correct: (f + x) = 5 with derivative 3, and (g − x²) = 2 with derivative −2 − 2 = −4, so h′(1) = 3·2 + 5·(−4) = −14.' from version_ins
union all select gen_random_uuid(), id, 'C', '−6', false, 'This differentiates the two factors without the terms from x and x², so it uses f′ and g′ alone.' from version_ins
union all select gen_random_uuid(), id, 'D', '26', false, 'This subtracts the second product-rule term instead of adding it, 3·2 − 5·(−4).' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.8-a-v3', 'mcq', 'differentiate a product of three factors, one given only by table values, tracking every term of the product rule. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g satisfy f(π) = 2, f′(π) = 4, g(π) = −3, and g′(π) = 5. Let h(x) = sin x·f(x)·g(x). What is h′(π)?', null, md5('apcalcbc-mcq-b5-sv-h-2.8-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', false, 'This uses cos π = +1 in the only surviving term, but cos π = −1.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', false, 'This differentiates only the product f·g, giving f′g + fg′, and ignores the factor sin x entirely.' from version_ins
union all select gen_random_uuid(), id, 'C', '−20', false, 'This multiplies the derivatives cos π, f′, and g′, instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', true, 'Correct: Since sin π = 0, only the term from differentiating sin x survives: h′(π) = cos π · f(π)·g(π) = (−1)(2)(−3) = 6.' from version_ins;
-- apcalcbc-mcq-b5-h-2.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.8-b', 'mcq', 'locate horizontal tangent lines of a product by solving f′ = 0, separating critical points from zeros of f and from erro', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For 0 < x ≤ π, at what value of x does the graph of f(x) = eˣ sin x have a horizontal tangent line?', null, md5('apcalcbc-mcq-b5-h-2.8-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3π/4', true, 'Correct: f′(x) = eˣ(sin x + cos x) = 0 gives tan x = −1, so x = 3π/4 on (0, π].' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/4', false, 'This uses f′(x) = eˣ(cos x − sin x), a sign error in the product rule, which gives tan x = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/2', false, 'This multiplies the derivatives eˣ and cos x instead of using the product rule, so it solves cos x = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π', false, 'This solves f(x) = 0 instead of f′(x) = 0; the zeros of f are not where its tangent is horizontal.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.8-b-v1', 'mcq', 'locate horizontal tangent lines of a product by solving f′ = 0, separating critical points from zeros of f and from erro (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For 0 < x ≤ π, at what value of x does the graph of f(x) = eˣ cos x have a horizontal tangent line?', null, md5('apcalcbc-mcq-b5-sv-h-2.8-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3π/4', false, 'This writes f′(x) = eˣ(cos x + sin x), a sign error in the derivative of cos x, which gives tan x = −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/2', false, 'This solves f(x) = 0 instead of f′(x) = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/4', true, 'Correct: f′(x) = eˣ(cos x − sin x) = 0 gives tan x = 1, so x = π/4 on (0, π].' from version_ins
union all select gen_random_uuid(), id, 'D', 'π', false, 'This multiplies the derivatives eˣ and −sin x instead of using the product rule, giving sin x = 0.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.8-b-v2', 'mcq', 'locate horizontal tangent lines of a product by solving f′ = 0, separating critical points from zeros of f and from erro (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, at what value of x does the graph of f(x) = x² ln x have a horizontal tangent line?', null, md5('apcalcbc-mcq-b5-sv-h-2.8-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This solves f(x) = 0 instead of f′(x) = 0; the zero of x² ln x is x = 1, where the tangent slope is 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'e^(−1)', false, 'This solves 2 ln x + 1 = 0 as ln x = −1, forgetting to divide by 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e^(1/2)', false, 'This solves 2 ln x + 1 = 0 as ln x = 1/2, a sign slip when isolating ln x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^(−1/2)', true, 'Correct: f′(x) = 2x ln x + x²(1/x) = x(2 ln x + 1) = 0 gives ln x = −1/2, so x = e^(−1/2).' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.7-b-v2','apcalcbc-mcq-b5-sv-h-2.7-b-v3','apcalcbc-mcq-b5-h-2.8-a','apcalcbc-mcq-b5-sv-h-2.8-a-v1','apcalcbc-mcq-b5-sv-h-2.8-a-v2','apcalcbc-mcq-b5-sv-h-2.8-a-v3','apcalcbc-mcq-b5-h-2.8-b','apcalcbc-mcq-b5-sv-h-2.8-b-v1','apcalcbc-mcq-b5-sv-h-2.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-sv-h-2.7-b-v2','apcalcbc-mcq-b5-sv-h-2.7-b-v3','apcalcbc-mcq-b5-h-2.8-a','apcalcbc-mcq-b5-sv-h-2.8-a-v1','apcalcbc-mcq-b5-sv-h-2.8-a-v2','apcalcbc-mcq-b5-sv-h-2.8-a-v3','apcalcbc-mcq-b5-h-2.8-b','apcalcbc-mcq-b5-sv-h-2.8-b-v1','apcalcbc-mcq-b5-sv-h-2.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
