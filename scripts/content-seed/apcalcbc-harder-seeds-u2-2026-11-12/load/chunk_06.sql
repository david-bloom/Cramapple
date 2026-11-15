begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.6-b-v1','apcalcbc-mcq-b5-sv-h-2.6-b-v2','apcalcbc-mcq-b5-sv-h-2.6-b-v3','apcalcbc-mcq-b5-h-2.7-a','apcalcbc-mcq-b5-sv-h-2.7-a-v1','apcalcbc-mcq-b5-sv-h-2.7-a-v2','apcalcbc-mcq-b5-sv-h-2.7-a-v3','apcalcbc-mcq-b5-h-2.7-b','apcalcbc-mcq-b5-sv-h-2.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-sv-h-2.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.6-b-v1', 'mcq', 'use f′ = c·g′ (or f′ = g′ + k) to conclude that a related combination of f and g is constant, rather than that f and g a (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are differentiable for all real x, and f′(x) = g′(x) + 3 for all x. Which statement must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.6-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = g(x) + 3 for all x.', false, 'The derivative of g(x) + 3 is g′(x), not g′(x) + 3, so adding the constant 3 to g does not produce the extra 3 in the derivative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) − g(x) is constant.', false, 'The difference f − g has derivative 3, not 0, so it changes at a constant rate rather than staying constant.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) − g(x) − 3x is constant.', true, 'Correct: (f − g − 3x)′ = f′ − g′ − 3 = 0 for all x, so f(x) − g(x) − 3x is constant.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = g(x) + 3x for all x.', false, 'This is the right growth rate, but it omits the possible constant: f(x) = g(x) + 3x + 7 also has f′ = g′ + 3.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.6-b-v2', 'mcq', 'use f′ = c·g′ (or f′ = g′ + k) to conclude that a related combination of f and g is constant, rather than that f and g a (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are differentiable for all real x, and f′(x) = 2g′(x) for all x. Which statement must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = 2g(x) for all x.', false, 'Equal derivatives of f and 2g allow a constant offset, for example g(x) = x and f(x) = 2x + 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) − g(x) is constant.', false, 'The difference f − g has derivative 2g′ − g′ = g′, which is not zero in general.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(0) = 2g(0).', false, 'Doubling the derivative does not force the values to match at any point, as with g(x) = x and f(x) = 2x + 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) − 2g(x) is constant.', true, 'Correct: (f − 2g)′ = f′ − 2g′ = 0 for all x, so f(x) − 2g(x) is constant.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.6-b-v3', 'mcq', 'use f′ = c·g′ (or f′ = g′ + k) to conclude that a related combination of f and g is constant, rather than that f and g a (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are differentiable for all real x, and f′(x) = −g′(x) for all x. Which statement must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.6-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = −g(x) for all x.', false, 'Opposite derivatives allow a constant offset, for example f(x) = x and g(x) = −x + 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) + g(x) is constant.', true, 'Correct: (f + g)′ = f′ + g′ = 0 for all x, so f(x) + g(x) is constant.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) − g(x) is constant.', false, 'The difference f − g has derivative f′ + f′ = 2f′, which is not zero in general.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x)·g(x) is constant.', false, 'Opposite derivatives say nothing about products; f(x) = x and g(x) = −x give a product −x², which is not constant.' from version_ins;
-- apcalcbc-mcq-b5-h-2.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.7-a', 'mcq', 'find the slope of a tangent line to y = ln x or y = eˣ that passes through a given external point, by solving the tangen', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A line through the origin is tangent to the graph of y = ln x. What is the slope of this line?', null, md5('apcalcbc-mcq-b5-h-2.7-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This is the slope of the tangent at x = 1, where the curve meets the x-axis, but that line does not pass through the origin.' from version_ins
union all select gen_random_uuid(), id, 'B', 'e', false, 'This reports the point of tangency x = e, found from ln a − 1 = 0, instead of the slope 1/a at that point.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/(e − 1)', false, 'This is the slope of the line through (1, 0) and (e, 1), which uses the x-intercept instead of the origin and is not tangent.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/e', true, 'Correct: The tangent at a is y = ln a + (x − a)/a; passing through (0, 0) gives ln a = 1, so a = e and the slope is 1/e.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.7-a-v1', 'mcq', 'find the slope of a tangent line to y = ln x or y = eˣ that passes through a given external point, by solving the tangen (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A line through the point (2, 0) is tangent to the graph of y = eˣ. What is the slope of this line?', null, md5('apcalcbc-mcq-b5-sv-h-2.7-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e²', false, 'This is the slope of the tangent at x = 2, but that line is y = e²(x − 1) and does not pass through (2, 0).' from version_ins
union all select gen_random_uuid(), id, 'B', 'e', false, 'This reverses (x − a) as (a − x) in the tangent equation, giving 1 + (a − 2) = 0 and a = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This reports the point of tangency a = 3 instead of the slope e^a = e³.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e³', true, 'Correct: The tangent at a is y = eᵃ + eᵃ(x − a); passing through (2, 0) gives 1 + 2 − a = 0, so a = 3 and the slope is e³.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.7-a-v2', 'mcq', 'find the slope of a tangent line to y = ln x or y = eˣ that passes through a given external point, by solving the tangen (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A line through the point (0, −2) is tangent to the graph of y = ln x. What is the slope of this line?', null, md5('apcalcbc-mcq-b5-sv-h-2.7-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/e', false, 'This reports the point of tangency a = 1/e instead of the slope 1/a = e.' from version_ins
union all select gen_random_uuid(), id, 'B', 'e', true, 'Correct: The tangent at a is y = ln a + (x − a)/a; at x = 0 it gives ln a − 1 = −2, so a = 1/e and the slope is 1/a = e.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e²', false, 'This sets ln a = −2 and ignores the −1 contributed by the tangent term, giving a = e⁻² and slope e².' from version_ins
union all select gen_random_uuid(), id, 'D', '1/e²', false, 'This reports the point a = e⁻² from setting ln a = −2, not the slope, and it also drops the −1 from the tangent term.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.7-a-v3', 'mcq', 'find the slope of a tangent line to y = ln x or y = eˣ that passes through a given external point, by solving the tangen (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A line through the point (−2, 0) is tangent to the graph of y = eˣ. What is the slope of this line?', null, md5('apcalcbc-mcq-b5-sv-h-2.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/e', true, 'Correct: The tangent at a is y = eᵃ + eᵃ(x − a); at (−2, 0) it gives 1 + (−2 − a) = 0, so a = −1 and the slope is e⁻¹.' from version_ins
union all select gen_random_uuid(), id, 'B', 'e⁻²', false, 'This is the slope of the tangent at x = −2 itself, but that line does not pass through (−2, 0) because it meets the curve there.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This reports the point of tangency a = −1 instead of the slope e^a = 1/e.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e', false, 'This writes 1 + (−2 + a) = 0 with a sign slip on a, giving a = 1 and slope e instead of a = −1 and slope 1/e.' from version_ins;
-- apcalcbc-mcq-b5-h-2.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.7-b', 'mcq', 'evaluate a high-order derivative of sin x, cos x, and eˣ by identifying the cycle of length four and the remainder of th', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = sin x. What is the 2025th derivative of f at x = π/3?', null, md5('apcalcbc-mcq-b5-h-2.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√3/2', false, 'This treats 2025 as a multiple of 4, where the derivative returns to sin x, but 2025 leaves remainder 1, which gives cos x.' from version_ins
union all select gen_random_uuid(), id, 'B', '−√3/2', false, 'This uses the cycle position for remainder 2, which gives −sin x, but 2025 leaves remainder 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', true, 'Correct: The derivatives of sin x cycle sin, cos, −sin, −cos; 2025 = 4·506 + 1, so f^(2025)(x) = cos x and the value is cos(π/3) = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/2', false, 'This uses the cycle position for remainder 3, which gives −cos x, but 2025 leaves remainder 1.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.7-b-v1', 'mcq', 'evaluate a high-order derivative of sin x, cos x, and eˣ by identifying the cycle of length four and the remainder of th (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = cos x. What is the 43rd derivative of f at x = π/6?', null, md5('apcalcbc-mcq-b5-sv-h-2.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/2', false, 'This takes the 43rd derivative as −sin x, the first derivative in the cycle, but 43 = 4·10 + 3 gives sin x.' from version_ins
union all select gen_random_uuid(), id, 'B', '√3/2', false, 'This treats 43 as a multiple of 4, where the derivative returns to cos x, but 43 leaves remainder 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', true, 'Correct: The derivatives of cos x cycle cos, −sin, −cos, sin; 43 = 4·10 + 3, so f^(43)(x) = sin x and the value is sin(π/6) = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−√3/2', false, 'This uses the cycle position for remainder 2, which gives −cos x, but 43 leaves remainder 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.6-b-v1','apcalcbc-mcq-b5-sv-h-2.6-b-v2','apcalcbc-mcq-b5-sv-h-2.6-b-v3','apcalcbc-mcq-b5-h-2.7-a','apcalcbc-mcq-b5-sv-h-2.7-a-v1','apcalcbc-mcq-b5-sv-h-2.7-a-v2','apcalcbc-mcq-b5-sv-h-2.7-a-v3','apcalcbc-mcq-b5-h-2.7-b','apcalcbc-mcq-b5-sv-h-2.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-sv-h-2.6-b-v1','apcalcbc-mcq-b5-sv-h-2.6-b-v2','apcalcbc-mcq-b5-sv-h-2.6-b-v3','apcalcbc-mcq-b5-h-2.7-a','apcalcbc-mcq-b5-sv-h-2.7-a-v1','apcalcbc-mcq-b5-sv-h-2.7-a-v2','apcalcbc-mcq-b5-sv-h-2.7-a-v3','apcalcbc-mcq-b5-h-2.7-b','apcalcbc-mcq-b5-sv-h-2.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
