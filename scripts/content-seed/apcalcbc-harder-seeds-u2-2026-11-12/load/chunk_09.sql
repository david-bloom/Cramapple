begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-h-2.10-a','apcalcbc-mcq-b5-sv-h-2.10-a-v1','apcalcbc-mcq-b5-sv-h-2.10-a-v2','apcalcbc-mcq-b5-sv-h-2.10-a-v3','apcalcbc-mcq-b5-h-2.10-b','apcalcbc-mcq-b5-sv-h-2.10-b-v1','apcalcbc-mcq-b5-sv-h-2.10-b-v2','apcalcbc-mcq-b5-sv-h-2.10-b-v3'])) then raise exception 'chunk 9 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-h-2.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.10-a', 'mcq', 'write and use the tangent line to y = sec x, csc x, cot x, or tan x at a point to find where that line crosses the x-axi', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the x-intercept of the line tangent to the graph of y = sec x at x = π/3?', null, md5('apcalcbc-mcq-b5-h-2.10-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/3 + √3/3', false, 'This reverses the sign: the tangent has positive slope 2√3 at a positive height 2, so it crosses the axis to the left of π/3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/3 − 1/2', false, 'This uses the slope sec² x = 4 instead of sec x tan x = 2√3, treating the derivative of sec x as that of tan x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/3 − √3/3', true, 'Correct: At π/3, y = 2 and y′ = sec x tan x = 2√3, so 0 = 2 + 2√3(x − π/3) gives x = π/3 − 1/√3 = π/3 − √3/3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/3 − 2√3', false, 'This uses the slope 2√3 as the horizontal shift instead of dividing the height 2 by the slope.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.10-a-v1', 'mcq', 'write and use the tangent line to y = sec x, csc x, cot x, or tan x at a point to find where that line crosses the x-axi (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the x-intercept of the line tangent to the graph of y = csc x at x = π/6?', null, md5('apcalcbc-mcq-b5-sv-h-2.10-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/6 + √3/3', true, 'Correct: At π/6, y = 2 and y′ = −csc x cot x = −2√3, so 0 = 2 − 2√3(x − π/6) gives x = π/6 + 1/√3 = π/6 + √3/3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/6 − √3/3', false, 'This uses the slope +csc x cot x, forgetting the minus sign, so the line crosses on the wrong side.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/6 + 1/2', false, 'This uses the slope −csc² x = −4 instead of −csc x cot x = −2√3, treating the derivative of csc x as that of cot x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/6 + 2√3', false, 'This uses the magnitude of the slope as the horizontal shift instead of dividing the height 2 by the slope.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.10-a-v2', 'mcq', 'write and use the tangent line to y = sec x, csc x, cot x, or tan x at a point to find where that line crosses the x-axi (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the x-intercept of the line tangent to the graph of y = cot x at x = π/4?', null, md5('apcalcbc-mcq-b5-sv-h-2.10-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/4 − 1/2', false, 'This uses the slope +csc² x = 2, forgetting the minus sign in the derivative of cot x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/4 + 1/2', true, 'Correct: At π/4, y = 1 and y′ = −csc² x = −2, so 0 = 1 − 2(x − π/4) gives x = π/4 + 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/4 + √2/2', false, 'This uses the slope −csc x cot x = −√2, treating the derivative of cot x as that of csc x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/4 + 2', false, 'This uses the magnitude of the slope as the horizontal shift instead of dividing the height 1 by the slope.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.10-a-v3', 'mcq', 'write and use the tangent line to y = sec x, csc x, cot x, or tan x at a point to find where that line crosses the x-axi (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the x-intercept of the line tangent to the graph of y = tan x at x = π/3?', null, md5('apcalcbc-mcq-b5-sv-h-2.10-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/3 − √3/4', true, 'Correct: At π/3, y = √3 and y′ = sec² x = 4, so 0 = √3 + 4(x − π/3) gives x = π/3 − √3/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/3 + √3/4', false, 'This reverses the sign: the tangent has positive slope 4 at a positive height √3, so it crosses to the left of π/3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/3 − 1/2', false, 'This uses the slope sec x tan x = 2√3 instead of sec² x = 4, treating the derivative of tan x as that of sec x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/3 − 4√3', false, 'This multiplies the height √3 by the slope 4 instead of dividing, so the shift is 4√3.' from version_ins;
-- apcalcbc-mcq-b5-h-2.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.10-b', 'mcq', 'simplify a product of trigonometric functions with an identity before differentiating, and recognize product-rule sign a', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = tan x · cos x for 0 < x < π/2. What is f′(π/3)?', null, md5('apcalcbc-mcq-b5-h-2.10-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7/2', false, 'This applies the product rule with the wrong sign, sec² x cos x + tan x sin x, instead of sec² x cos x − tan x sin x.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2', true, 'Correct: tan x cos x = sin x, so f′(x) = cos x and f′(π/3) = 1/2; the product rule gives the same, 2 − 3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2√3', false, 'This multiplies the derivatives sec² x and −sin x instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '√3/2', false, 'This simplifies tan x cos x to sin x correctly but then differentiates sin x as sin x instead of cos x.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.10-b-v1', 'mcq', 'simplify a product of trigonometric functions with an identity before differentiating, and recognize product-rule sign a (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = cot x · sin x for 0 < x < π. What is f′(π/6)?', null, md5('apcalcbc-mcq-b5-sv-h-2.10-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2√3', false, 'This multiplies the derivatives −csc² x and cos x instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '−7/2', false, 'This applies the product rule with the wrong sign, −csc² x sin x − cot x cos x, instead of adding cot x cos x.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', false, 'This simplifies cot x sin x to cos x correctly but then differentiates cos x as sin x, missing the minus sign.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/2', true, 'Correct: cot x sin x = cos x, so f′(x) = −sin x and f′(π/6) = −1/2; the product rule gives −2 + 3/2 = −1/2.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.10-b-v2', 'mcq', 'simplify a product of trigonometric functions with an identity before differentiating, and recognize product-rule sign a (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = sec x · cot x for 0 < x < π/2. What is f′(π/4)?', null, md5('apcalcbc-mcq-b5-sv-h-2.10-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2√2', false, 'This multiplies the derivatives sec x tan x and −csc² x instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '√2', false, 'This simplifies sec x cot x to csc x correctly but then differentiates csc x without the minus sign.' from version_ins
union all select gen_random_uuid(), id, 'C', '3√2', false, 'This applies the product rule with the wrong sign, sec x tan x cot x − sec x(−csc² x), so the two terms add instead of partially cancelling.' from version_ins
union all select gen_random_uuid(), id, 'D', '−√2', true, 'Correct: sec x cot x = csc x, so f′(x) = −csc x cot x and f′(π/4) = −√2; the product rule gives √2 − 2√2.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.10-b-v3', 'mcq', 'simplify a product of trigonometric functions with an identity before differentiating, and recognize product-rule sign a (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = csc x · tan x for 0 < x < π/2. What is f′(π/3)?', null, md5('apcalcbc-mcq-b5-sv-h-2.10-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−8/3', false, 'This multiplies the derivatives −csc x cot x and sec² x instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This simplifies csc x tan x to sec x correctly but then differentiates sec x as sec² x instead of sec x tan x.' from version_ins
union all select gen_random_uuid(), id, 'C', '2√3', true, 'Correct: csc x tan x = sec x, so f′(x) = sec x tan x and f′(π/3) = 2√3; the product rule gives −2/√3 + 8/√3 = 6/√3 = 2√3.' from version_ins
union all select gen_random_uuid(), id, 'D', '−10√3/3', false, 'This applies the product rule with the wrong sign, so the two terms −2/√3 and 8/√3 are both taken negative.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-h-2.10-a','apcalcbc-mcq-b5-sv-h-2.10-a-v1','apcalcbc-mcq-b5-sv-h-2.10-a-v2','apcalcbc-mcq-b5-sv-h-2.10-a-v3','apcalcbc-mcq-b5-h-2.10-b','apcalcbc-mcq-b5-sv-h-2.10-b-v1','apcalcbc-mcq-b5-sv-h-2.10-b-v2','apcalcbc-mcq-b5-sv-h-2.10-b-v3']) and status='draft')<>8 then raise exception 'chunk 9: expected 8 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-h-2.10-a','apcalcbc-mcq-b5-sv-h-2.10-a-v1','apcalcbc-mcq-b5-sv-h-2.10-a-v2','apcalcbc-mcq-b5-sv-h-2.10-a-v3','apcalcbc-mcq-b5-h-2.10-b','apcalcbc-mcq-b5-sv-h-2.10-b-v1','apcalcbc-mcq-b5-sv-h-2.10-b-v2','apcalcbc-mcq-b5-sv-h-2.10-b-v3']))<>32 then raise exception 'chunk 9: expected 32 choices'; end if;
end $$;
commit;
