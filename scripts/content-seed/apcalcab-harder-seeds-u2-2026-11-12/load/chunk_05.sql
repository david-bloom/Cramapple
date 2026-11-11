begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-h-2.5-b','apcalcab-mcq-b5-sv-h-2.5-b-v1','apcalcab-mcq-b5-sv-h-2.5-b-v2','apcalcab-mcq-b5-sv-h-2.5-b-v3','apcalcab-mcq-b5-h-2.6-a','apcalcab-mcq-b5-sv-h-2.6-a-v1','apcalcab-mcq-b5-sv-h-2.6-a-v2','apcalcab-mcq-b5-sv-h-2.6-a-v3','apcalcab-mcq-b5-h-2.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-h-2.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.5-b', 'mcq', 'use the power rule to find where a rate of change numerically equals the quantity itself in a geometric context.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The volume of a cube with side length s centimeters is V(s) = s³ cubic centimeters. For what positive side length is the rate of change of V with respect to s, in cubic centimeters per centimeter, numerically equal to V?', null, md5('apcalcab-mcq-b5-h-2.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 's = √3', false, 'This uses V′(s) = 3s instead of 3s². Setting 3s = s³ gives s = √3, which is not a solution of 3s² = s³.' from version_ins
union all select gen_random_uuid(), id, 'B', 's = 6', false, 'The value 6 comes from setting the surface area 6s² equal to the volume. The question is about the rate of change of the volume.' from version_ins
union all select gen_random_uuid(), id, 'C', 's = 1/3', false, 'This inverts the result of solving 3s² = s³, which gives s = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 's = 3', true, 'Correct: V′(s) = 3s². Setting 3s² = s³ gives s²(3 − s) = 0, so s = 3 for s > 0.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.5-b-v1', 'mcq', 'use the power rule to find where a rate of change numerically equals the quantity itself in a geometric context. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The area of a circle with radius r centimeters is A(r) = πr² square centimeters. For what positive radius is the rate of change of A with respect to r, in square centimeters per centimeter, numerically equal to A?', null, md5('apcalcab-mcq-b5-sv-h-2.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'r = 1', false, 'This uses A′(r) = πr instead of 2πr. Setting πr = πr² gives r = 1, which does not satisfy 2πr = πr².' from version_ins
union all select gen_random_uuid(), id, 'B', 'r = √2', false, 'This treats r as constant when differentiating, getting A′ = 2π and then 2π = πr², so r = √2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'r = 1/2', false, 'This inverts the result of solving 2πr = πr², which gives r = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'r = 2', true, 'Correct: A′(r) = 2πr. Setting 2πr = πr² gives r(r − 2) = 0, so r = 2 for r > 0.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.5-b-v2', 'mcq', 'use the power rule to find where a rate of change numerically equals the quantity itself in a geometric context. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The amount of a drug in the bloodstream is P(x) = x^(3/2) milligrams, x hours after infusion begins. For what positive x is the rate of change of P, in milligrams per hour, numerically equal to P(x)?', null, md5('apcalcab-mcq-b5-sv-h-2.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 9/4', false, 'This squares the correct value. Setting (3/2)x^(1/2) = x^(3/2) and dividing by x^(1/2) gives x = 3/2 directly, with no further squaring.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 3/2', true, 'Correct: P′(x) = (3/2)x^(1/2). Setting (3/2)x^(1/2) = x^(3/2) and dividing by x^(1/2) gives x = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 2/3', false, 'This inverts the result. The equation (3/2)x^(1/2) = x^(3/2) gives x = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 3', false, 'This uses P′(x) = 3x^(1/2) by doubling the exponent instead of multiplying by 3/2. The correct coefficient is 3/2.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.5-b-v3', 'mcq', 'use the power rule to find where a rate of change numerically equals the quantity itself in a geometric context. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of bacteria in a culture is N(t) = t⁵ thousand, t hours after the start. For what positive time t is the rate of growth, in thousands per hour, numerically equal to N(t)?', null, md5('apcalcab-mcq-b5-sv-h-2.5-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 1/5', false, 'This inverts the answer. The equation 5t⁴ = t⁵ gives t = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 4', false, 'This uses the lowered exponent as the answer. The equation is 5t⁴ = t⁵, whose positive solution is the coefficient 5, not the exponent 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 5', true, 'Correct: N′(t) = 5t⁴. Setting 5t⁴ = t⁵ gives t⁴(5 − t) = 0, so t = 5 for t > 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 25', false, 'This squares the correct value. Dividing 5t⁴ = t⁵ by t⁴ gives t = 5 directly.' from version_ins;
-- apcalcab-mcq-b5-h-2.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.6-a', 'mcq', 'use the fact that a constant term disappears under differentiation to choose the constant that makes a horizontal line t', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³ − 3x² + k, where k is a constant. For which values of k is the horizontal line y = 5 tangent to the graph of f?', null, md5('apcalcab-mcq-b5-h-2.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 5 only', false, 'Here f′(x) = 3x² − 6x = 0 at x = 0 and x = 2. Using only x = 0 gives f(0) = k = 5 but misses that the graph is also horizontal at x = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 5 or k = 9', true, 'Correct: f′(x) = 3x² − 6x is zero at x = 0 and x = 2. Tangency to y = 5 needs f(0) = k = 5 or f(2) = k − 4 = 5, so k = 5 or k = 9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 9 only', false, 'Using only x = 2 gives f(2) = k − 4 = 5, so k = 9, but it misses that f is also horizontal at x = 0, where f(0) = k = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 1 or k = 5', false, 'This has a sign error at x = 2: f(2) = 8 − 12 + k = k − 4, so f(2) = 5 gives k = 9, not k = 1.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.6-a-v1', 'mcq', 'use the fact that a constant term disappears under differentiation to choose the constant that makes a horizontal line t (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³ − 12x + k, where k is a constant. For which values of k is the x-axis tangent to the graph of f?', null, md5('apcalcab-mcq-b5-sv-h-2.6-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 16 or k = −16', true, 'Correct: f′(x) = 3x² − 12 is zero at x = ±2. Tangency to y = 0 needs f(2) = k − 16 = 0 or f(−2) = k + 16 = 0, so k = 16 or k = −16.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 16 only', false, 'Here f′(x) = 3x² − 12 is zero at x = 2 and x = −2. The value k = 16 comes from x = 2, but x = −2 gives f(−2) = 16 + k = 0, so k = −16 also works.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 0', false, 'The constant k does not disappear from f; it only disappears from f′. The horizontal tangent at x = ±2 needs f(±2) = 0, which fixes k.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 2 or k = −2', false, 'The values ±2 are the x-coordinates where f′ = 0, not the values of k. Tangency to the x-axis needs f(±2) = 0.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.6-a-v2', 'mcq', 'use the fact that a constant term disappears under differentiation to choose the constant that makes a horizontal line t (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 2x³ − 9x² + k, where k is a constant. For which values of k is the horizontal line y = −4 tangent to the graph of f?', null, md5('apcalcab-mcq-b5-sv-h-2.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −4 only', false, 'Here f′(x) = 6x² − 18x is zero at x = 0 and x = 3. Using only x = 0 gives f(0) = k = −4 but misses the second point of tangency at x = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 23 only', false, 'Using only x = 3 gives f(3) = k − 27 = −4, so k = 23, but it misses the horizontal tangent at x = 0, where f(0) = k = −4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = −4 or k = 23', true, 'Correct: f′(x) = 6x² − 18x is zero at x = 0 and x = 3. Tangency to y = −4 needs f(0) = k = −4 or f(3) = k − 27 = −4, so k = −4 or k = 23.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 4 or k = −23', false, 'This reverses the sign of both values. The conditions f(0) = k = −4 and f(3) = k − 27 = −4 give k = −4 and k = 23, not 4 and −23.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.6-a-v3', 'mcq', 'use the fact that a constant term disappears under differentiation to choose the constant that makes a horizontal line t (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x⁴ − 8x² + k, where k is a constant. For which values of k is the horizontal line y = 3 tangent to the graph of f?', null, md5('apcalcab-mcq-b5-sv-h-2.6-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 3 only', false, 'Here f′(x) = 4x³ − 16x is zero at x = 0 and x = ±2. Using only x = 0 gives f(0) = k = 3 but misses the horizontal tangents at x = ±2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 19 only', false, 'Using only x = ±2 gives f(±2) = k − 16 = 3, so k = 19, but it misses the horizontal tangent at x = 0, where f(0) = k = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = −13 or k = 3', false, 'This has a sign error at x = ±2: f(±2) = 16 − 32 + k = k − 16, so f(±2) = 3 gives k = 19, not k = −13.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 3 or k = 19', true, 'Correct: f′(x) = 4x³ − 16x is zero at x = 0 and x = ±2. Tangency to y = 3 needs f(0) = k = 3 or f(±2) = k − 16 = 3, so k = 3 or k = 19.' from version_ins;
-- apcalcab-mcq-b5-h-2.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.6-b', 'mcq', 'work backward from a given derivative of a combination to the derivative of a component function, using the sum and cons', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function, and let g(x) = 4f(x) − x². The tangent line to the graph of g at x = 2 has slope 6. What is f′(2)?', null, md5('apcalcab-mcq-b5-h-2.6-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/2', true, 'Correct: g′(x) = 4f′(x) − 2x, so g′(2) = 4f′(2) − 4 = 6, which gives 4f′(2) = 10 and f′(2) = 5/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/2', false, 'This ignores the −x² term. From 4f′(2) = 6 it gives 3/2, but g′(x) = 4f′(x) − 2x, so at x = 2 the term −4 must be included.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This solves 4f′(2) − 4 = 6 incorrectly by subtracting 4 from 6 and not dividing by 4. The correct step is 4f′(2) = 10.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This has a sign error on the x² term: it solves 4f′(2) + 4 = 6, but the derivative of −x² is −2x, which is −4 at x = 2.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-h-2.5-b','apcalcab-mcq-b5-sv-h-2.5-b-v1','apcalcab-mcq-b5-sv-h-2.5-b-v2','apcalcab-mcq-b5-sv-h-2.5-b-v3','apcalcab-mcq-b5-h-2.6-a','apcalcab-mcq-b5-sv-h-2.6-a-v1','apcalcab-mcq-b5-sv-h-2.6-a-v2','apcalcab-mcq-b5-sv-h-2.6-a-v3','apcalcab-mcq-b5-h-2.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-h-2.5-b','apcalcab-mcq-b5-sv-h-2.5-b-v1','apcalcab-mcq-b5-sv-h-2.5-b-v2','apcalcab-mcq-b5-sv-h-2.5-b-v3','apcalcab-mcq-b5-h-2.6-a','apcalcab-mcq-b5-sv-h-2.6-a-v1','apcalcab-mcq-b5-sv-h-2.6-a-v2','apcalcab-mcq-b5-sv-h-2.6-a-v3','apcalcab-mcq-b5-h-2.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
