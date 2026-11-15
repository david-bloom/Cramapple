begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.7-b-v2','apcalcab-mcq-b5-sv-h-2.7-b-v3','apcalcab-mcq-b5-h-2.8-a','apcalcab-mcq-b5-sv-h-2.8-a-v1','apcalcab-mcq-b5-sv-h-2.8-a-v2','apcalcab-mcq-b5-sv-h-2.8-a-v3','apcalcab-mcq-b5-h-2.8-b','apcalcab-mcq-b5-sv-h-2.8-b-v1','apcalcab-mcq-b5-sv-h-2.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-sv-h-2.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.7-b-v2', 'mcq', 'differentiate a sum that contains constant-valued exponential, logarithmic and trigonometric terms without treating the  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = cos x + x sin(π/6) + cos(π/3). What is h′(π/2)?', null, md5('apcalcab-mcq-b5-sv-h-2.7-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/2 − √3/2', false, 'This differentiates cos(π/3), a constant, as −sin(π/3) = −√3/2. The derivative of a constant is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/2', true, 'Correct: h′(x) = −sin x + sin(π/6) + 0 = −sin x + 1/2, so h′(π/2) = −1 + 1/2 = −1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/2', false, 'This has a sign error on cos x, which has derivative −sin x. Using +sin x gives 1 + 1/2 = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1 + π√3/4', false, 'This differentiates x sin(π/6) as x cos(π/6), applying the sine rule to a constant. The derivative is the constant sin(π/6) = 1/2.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.7-b-v3', 'mcq', 'differentiate a sum that contains constant-valued exponential, logarithmic and trigonometric terms without treating the  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let p(x) = πx + ln x + e^π for x > 0. What is p′(2)?', null, md5('apcalcab-mcq-b5-sv-h-2.7-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π + 1/2 + e^π', false, 'This differentiates the constant e^π as e^π, as if it were eˣ. The derivative of a constant is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2', false, 'This treats πx as a constant and drops it. The derivative of πx is π.' from version_ins
union all select gen_random_uuid(), id, 'C', '2π + 1/2', false, 'This differentiates πx as πx, leaving the factor of x. The derivative of πx is the constant π.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π + 1/2', true, 'Correct: p′(x) = π + 1/x + 0, so p′(2) = π + 1/2.' from version_ins;
-- apcalcab-mcq-b5-h-2.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.8-a', 'mcq', 'use the product rule backward: a horizontal tangent to a product determines the derivative of one factor.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f(3) = 2, and let h(x) = x²f(x). The graph of h has a horizontal tangent line at x = 3. What is f′(3)?', null, md5('apcalcab-mcq-b5-h-2.8-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4/3', true, 'Correct: h′(x) = 2x f(x) + x² f′(x), so h′(3) = 6(2) + 9f′(3) = 12 + 9f′(3). Setting this to 0 gives f′(3) = −12/9 = −4/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This differentiates the product as 2x · f′(x), the product of the derivatives of the factors with f dropped. That would give f′(3) = 0, but h′ = 2xf + x²f′.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3', false, 'This swaps the roles in the product rule, writing h′ = x²f + 2xf′. Setting 9(2) + 6f′(3) = 0 gives −3, which is not the correct equation.' from version_ins
union all select gen_random_uuid(), id, 'D', '4/3', false, 'This has a sign error: 12 + 9f′(3) = 0 gives f′(3) = −12/9, so the result is negative, not positive.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.8-a-v1', 'mcq', 'use the product rule backward: a horizontal tangent to a product determines the derivative of one factor. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f(4) = 6, and let h(x) = √x · f(x). The graph of h has a horizontal tangent line at x = 4. What is f′(4)?', null, md5('apcalcab-mcq-b5-sv-h-2.8-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This differentiates the product as the product of the derivatives, (1/(2√x))f′(x), which is zero only if f′(4) = 0. The product rule has two terms.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/2', false, 'This writes the derivative of √x as 1/√x instead of 1/(2√x), so the first term becomes 6/2 = 3 instead of 6/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/4', false, 'This has a sign error: 6/4 + 2f′(4) = 0 gives a negative f′(4), not a positive one.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3/4', true, 'Correct: h′(x) = f(x)/(2√x) + √x f′(x), so h′(4) = 6/4 + 2f′(4) = 0, which gives f′(4) = −3/4.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.8-a-v2', 'mcq', 'use the product rule backward: a horizontal tangent to a product determines the derivative of one factor. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f(0) = 7, and let h(x) = eˣ f(x). The graph of h has a horizontal tangent line at x = 0. What is f′(0)?', null, md5('apcalcab-mcq-b5-sv-h-2.8-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This differentiates the product as eˣ · f′(x), the product of the derivatives with f dropped. The product rule also contributes eˣ f(x).' from version_ins
union all select gen_random_uuid(), id, 'B', '−7', true, 'Correct: h′(x) = eˣ f(x) + eˣ f′(x), so h′(0) = 7 + f′(0) = 0, which gives f′(0) = −7.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'This has a sign error: e⁰(7 + f′(0)) = 0 gives f′(0) = −7, not 7.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/7', false, 'This divides the wrong way, using 1/f(0) instead of f(0). Setting h′(0) = f(0) + f′(0) = 0 gives f′(0) = −f(0).' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.8-a-v3', 'mcq', 'use the product rule backward: a horizontal tangent to a product determines the derivative of one factor. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f(e) = 3, and let h(x) = f(x) ln x. The graph of h has a horizontal tangent line at x = e. What is f′(e)?', null, md5('apcalcab-mcq-b5-sv-h-2.8-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This differentiates the product as f′(x) · (1/x), the product of the derivatives. The product rule has a second term f(x)/x.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3', false, 'This writes the derivative of ln x as 1 instead of 1/x, so the first term becomes f(e) = 3 instead of 3/e.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/e', false, 'This has a sign error: 3/e + f′(e) = 0 gives f′(e) = −3/e, not +3/e.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3/e', true, 'Correct: h′(x) = f′(x) ln x + f(x)/x, so h′(e) = f′(e) + 3/e = 0, which gives f′(e) = −3/e.' from version_ins;
-- apcalcab-mcq-b5-h-2.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.8-b', 'mcq', 'apply the product rule to a rate in context, such as revenue as price times quantity, and interpret the result with unit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company sells q units at a price of p(q) dollars per unit, so its revenue is R(q) = q · p(q) dollars. When q = 100, the price is p(100) = 12 dollars and p′(100) = −0.05 dollar per unit. Which statement is the best interpretation of R′(100)?', null, md5('apcalcab-mcq-b5-h-2.8-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Selling one more unit beyond 100 changes revenue by about +7 dollars.', true, 'Correct: R′(q) = p(q) + q p′(q), so R′(100) = 12 + 100(−0.05) = 7 dollars per unit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Selling one more unit beyond 100 changes revenue by about +12 dollars.', false, 'This takes R′ to be the price p(100). It forgets that a higher quantity also lowers the price on all the units already sold, a term q p′(q).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Selling one more unit beyond 100 changes revenue by about −0.6 dollar.', false, 'This multiplies the price by its rate of change, 12 · (−0.05) = −0.6. The product rule gives p(q) + q p′(q), not p(q) p′(q).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Selling one more unit beyond 100 changes revenue by about +11.95 dollars.', false, 'This adds p and p′ without the factor q, giving 12 − 0.05. The second product-rule term is q p′(q) = 100(−0.05) = −5.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.8-b-v1', 'mcq', 'apply the product rule to a rate in context, such as revenue as price times quantity, and interpret the result with unit (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rectangle has length ℓ(t) meters and width w(t) meters at time t minutes, so its area is A(t) = ℓ(t)w(t). At t = 5, ℓ = 20, ℓ′ = 1.5, w = 8 and w′ = −0.5. What is the rate of change of the area at t = 5?', null, md5('apcalcab-mcq-b5-sv-h-2.8-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−0.75 square meters per minute', false, 'This multiplies the rates, 1.5 · (−0.5). The product rule gives ℓ′w + ℓw′, not ℓ′w′.' from version_ins
union all select gen_random_uuid(), id, 'B', '26 square meters per minute', false, 'This pairs each derivative with its own function, ℓ′ℓ + w′w = 30 − 4, instead of cross-multiplying as ℓ′w + ℓw′.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 square meters per minute', true, 'Correct: A′ = ℓ′w + ℓw′ = (1.5)(8) + (20)(−0.5) = 12 − 10 = 2 square meters per minute.' from version_ins
union all select gen_random_uuid(), id, 'D', '1 square meter per minute', false, 'This adds the rates, 1.5 + (−0.5), ignoring the current length and width. Area rates depend on both dimensions.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.8-b-v2', 'mcq', 'apply the product rule to a rate in context, such as revenue as price times quantity, and interpret the result with unit (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fundraiser has n(t) donors and an average gift of a(t) dollars at day t, so total pledges are T(t) = n(t)a(t) dollars. At t = 10, n = 200, n′ = 15 donors per day, a = 40 and a′ = −1.5 dollars per day. What is the best estimate of T′(10)?', null, md5('apcalcab-mcq-b5-sv-h-2.8-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '600 dollars per day', false, 'This keeps only the new-donor term n′a = 600 and omits n a′ = −300, the loss from falling average gifts.' from version_ins
union all select gen_random_uuid(), id, 'B', '−22.5 dollars per day', false, 'This multiplies the two rates, 15 · (−1.5). The product rule gives n′a + na′, not n′a′.' from version_ins
union all select gen_random_uuid(), id, 'C', '8000 dollars per day', false, 'This is the current total pledged, T(10) = 200 · 40, a quantity in dollars rather than a rate in dollars per day.' from version_ins
union all select gen_random_uuid(), id, 'D', '300 dollars per day', true, 'Correct: T′ = n′a + na′ = (15)(40) + (200)(−1.5) = 600 − 300 = 300 dollars per day.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.7-b-v2','apcalcab-mcq-b5-sv-h-2.7-b-v3','apcalcab-mcq-b5-h-2.8-a','apcalcab-mcq-b5-sv-h-2.8-a-v1','apcalcab-mcq-b5-sv-h-2.8-a-v2','apcalcab-mcq-b5-sv-h-2.8-a-v3','apcalcab-mcq-b5-h-2.8-b','apcalcab-mcq-b5-sv-h-2.8-b-v1','apcalcab-mcq-b5-sv-h-2.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-sv-h-2.7-b-v2','apcalcab-mcq-b5-sv-h-2.7-b-v3','apcalcab-mcq-b5-h-2.8-a','apcalcab-mcq-b5-sv-h-2.8-a-v1','apcalcab-mcq-b5-sv-h-2.8-a-v2','apcalcab-mcq-b5-sv-h-2.8-a-v3','apcalcab-mcq-b5-h-2.8-b','apcalcab-mcq-b5-sv-h-2.8-b-v1','apcalcab-mcq-b5-sv-h-2.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
