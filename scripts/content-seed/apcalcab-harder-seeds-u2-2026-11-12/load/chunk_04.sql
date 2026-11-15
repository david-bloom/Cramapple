begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.4-a-v3','apcalcab-mcq-b5-h-2.4-b','apcalcab-mcq-b5-sv-h-2.4-b-v1','apcalcab-mcq-b5-sv-h-2.4-b-v2','apcalcab-mcq-b5-sv-h-2.4-b-v3','apcalcab-mcq-b5-h-2.5-a','apcalcab-mcq-b5-sv-h-2.5-a-v1','apcalcab-mcq-b5-sv-h-2.5-a-v2','apcalcab-mcq-b5-sv-h-2.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-sv-h-2.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.4-a-v3', 'mcq', 'choose constants that make a piecewise function both continuous and differentiable at the join, using the slopes and val (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = ax² + bx for x ≤ 1 and f(x) = 2 ln x + 3 for x > 1. For which values of a and b is f differentiable at x = 1?', null, md5('apcalcab-mcq-b5-sv-h-2.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 1 and b = 2', false, 'This satisfies continuity (1 + 2 = 3), but the left slope is 2a + b = 4 while the right slope is 2, so the graph has a corner at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 1 and b = 0', false, 'The slope condition 2a + b = 2 holds, but a + b = 1 while the right piece equals 3 at x = 1, so f has a jump at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 2 and b = −2', false, 'This ignores the +3 in the right piece, matching a + b to 2 ln 1 = 0. The right piece actually equals 3 at x = 1, so f has a jump there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = −1 and b = 4', true, 'Correct: Continuity needs a + b = 2 ln 1 + 3 = 3. Equal slopes need 2a + b = 2/x = 2 at x = 1. Subtracting gives a = −1, so b = 4.' from version_ins;
-- apcalcab-mcq-b5-h-2.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.4-b', 'mcq', 'count the points where the absolute value of a polynomial fails to be differentiable by telling simple roots from repeat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = |(x − 2)²(x + 1)|. At how many values of x is f not differentiable?', null, md5('apcalcab-mcq-b5-h-2.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', true, 'Correct: Near x = 2, (x − 2)²(x + 1) is positive, so f equals the smooth polynomial there. Only the sign change at x = −1 produces a corner, so there is 1 point.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'The absolute value of a polynomial can have corners where the polynomial crosses zero. At x = −1 the factor x + 1 changes sign, so there is a corner there.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'Counting both zeros forgets that (x − 2)² does not change sign at x = 2. Near 2, f(x) = (x − 2)²(x + 1), which is smooth.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'Counting the roots with multiplicity (2 at x = 2 and 1 at x = −1) does not reflect where the graph has corners. Only a sign change creates one.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.4-b-v1', 'mcq', 'count the points where the absolute value of a polynomial fails to be differentiable by telling simple roots from repeat (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = |x(x − 3)²(x + 2)|. At how many values of x is f not differentiable?', null, md5('apcalcab-mcq-b5-sv-h-2.4-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', false, 'Counting all three zeros ignores that (x − 3)² does not change sign at x = 3, so f is smooth there.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'Counting only one zero misses that both x and x + 2 change sign. Each simple root gives a corner in the absolute value.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'The absolute value is not automatically differentiable where the inside is. At a simple root such as x = 0 the one-sided slopes are opposite.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', true, 'Correct: The factors x and x + 2 each change sign once, giving corners at x = 0 and x = −2. The squared factor leaves f smooth at x = 3, so there are 2 points.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.4-b-v2', 'mcq', 'count the points where the absolute value of a polynomial fails to be differentiable by telling simple roots from repeat (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = |(x − 1)³(x + 2)²|. At how many values of x is f not differentiable?', null, md5('apcalcab-mcq-b5-sv-h-2.4-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'The triple root is a trap: (x − 1)³ changes sign, but |(x − 1)³| = |x − 1|³ has one-sided slopes that both equal 0 at x = 1, so there is no corner.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'Counting both distinct zeros assumes every zero produces a corner. A zero of order 2 or higher, with a vanishing derivative, does not.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'Adding the multiplicities (3 + 2) counts something unrelated to corners of the graph.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', true, 'Correct: At x = 1, f(x) = |x − 1|³(x + 2)², whose derivative from both sides is 0. At x = −2 the squared factor does not change sign. So f is differentiable everywhere.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.4-b-v3', 'mcq', 'count the points where the absolute value of a polynomial fails to be differentiable by telling simple roots from repeat (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = |x³ − 9x|. At how many values of x is f not differentiable?', null, md5('apcalcab-mcq-b5-sv-h-2.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', true, 'Correct: x³ − 9x = x(x − 3)(x + 3) has three simple roots at 0, 3 and −3. Each is a sign change with nonzero slope, so the absolute value has three corners.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'The zeros are x = 0, 3 and −3. Counting only x = 0 ignores that the polynomial also crosses zero at x = 3 and x = −3.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'Counting only the two nonzero roots forgets that the polynomial also changes sign at x = 0, where the factor x is simple.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The absolute value is not smooth where a simple root makes the inside change sign. Each of the three crossings is a corner.' from version_ins;
-- apcalcab-mcq-b5-h-2.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.5-a', 'mcq', 'find the points of tangency of lines drawn from an external point to a power-function curve.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two lines pass through the point (1, −3) and are tangent to the graph of y = x². What are the x-coordinates of the points of tangency?', null, md5('apcalcab-mcq-b5-h-2.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = −1 and x = 3', true, 'Correct: The tangent at x = a is y = a² + 2a(x − a). It passes through (1, −3) when −3 = a² + 2a(1 − a), so a² − 2a − 3 = 0 and a = 3 or a = −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 1', false, 'The point (1, −3) is not on the parabola, since 1² = 1. It is the external point the lines pass through, not a point of tangency.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 3', false, 'This keeps only the positive solution. The equation a² − 2a − 3 = 0 has two roots, and the second line is tangent where x = −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = −3 and x = 1', false, 'This factors a² − 2a − 3 as (a + 3)(a − 1), which expands to a² + 2a − 3. The correct factors are (a − 3)(a + 1).' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.5-a-v1', 'mcq', 'find the points of tangency of lines drawn from an external point to a power-function curve. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A line through the point (−2, 0) is tangent to the graph of y = √x. What is the x-coordinate of the point of tangency?', null, md5('apcalcab-mcq-b5-sv-h-2.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = −2', false, 'The point (−2, 0) is the external point the line passes through; it is not on the graph of √x, which is defined only for x ≥ 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 2', true, 'Correct: The tangent at x = a is y = √a + (x − a)/(2√a). It passes through (−2, 0) when 0 = √a + (−2 − a)/(2√a), so 2a = 2 + a and a = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 1', false, 'The point (1, 1) is on the curve, but the tangent there is y = 1 + (x − 1)/2, which crosses the x-axis at x = −1, not at −2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 4', false, 'At x = 4 the tangent is y = 2 + (x − 4)/4, which crosses the x-axis at x = −4, not at −2.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.5-a-v2', 'mcq', 'find the points of tangency of lines drawn from an external point to a power-function curve. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two lines pass through the point (2, −5) and are tangent to the graph of y = x². What are the x-coordinates of the points of tangency?', null, md5('apcalcab-mcq-b5-sv-h-2.5-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 5', false, 'This keeps only the positive root of a² − 4a − 5 = 0. The second solution a = −1 gives a second tangent line.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 2', false, 'The x-coordinate of the given point is 2, but the point (2, −5) is not on the parabola (where y would be 4). It is the external point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = −1 and x = 5', true, 'Correct: The tangent at x = a is y = a² + 2a(x − a). It passes through (2, −5) when −5 = a² + 2a(2 − a), so a² − 4a − 5 = 0 and a = 5 or a = −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 1 and x = −5', false, 'This factors a² − 4a − 5 as (a − 1)(a + 5), which expands to a² + 4a − 5. The correct factors are (a − 5)(a + 1).' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.5-a-v3', 'mcq', 'find the points of tangency of lines drawn from an external point to a power-function curve. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A line through the point (3, 0) is tangent to the graph of y = 1/x for x > 0. What is the x-coordinate of the point of tangency?', null, md5('apcalcab-mcq-b5-sv-h-2.5-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 3', false, 'The x-coordinate of the given point is 3, but that is where the line crosses the x-axis. The point of tangency is on the curve, so its y-coordinate is not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 2/3', false, 'This inverts the answer. At x = 2/3 the tangent line is y = 3 − (9/4)x, which crosses the x-axis at x = 4/3, not at 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 3/2', true, 'Correct: The tangent at x = a is y = 2/a − x/a². It passes through (3, 0) when 2/a = 3/a², so a = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 1/3', false, 'At x = 1/3 the tangent has slope −9 and meets the x-axis at x = 2/3, not 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.4-a-v3','apcalcab-mcq-b5-h-2.4-b','apcalcab-mcq-b5-sv-h-2.4-b-v1','apcalcab-mcq-b5-sv-h-2.4-b-v2','apcalcab-mcq-b5-sv-h-2.4-b-v3','apcalcab-mcq-b5-h-2.5-a','apcalcab-mcq-b5-sv-h-2.5-a-v1','apcalcab-mcq-b5-sv-h-2.5-a-v2','apcalcab-mcq-b5-sv-h-2.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-sv-h-2.4-a-v3','apcalcab-mcq-b5-h-2.4-b','apcalcab-mcq-b5-sv-h-2.4-b-v1','apcalcab-mcq-b5-sv-h-2.4-b-v2','apcalcab-mcq-b5-sv-h-2.4-b-v3','apcalcab-mcq-b5-h-2.5-a','apcalcab-mcq-b5-sv-h-2.5-a-v1','apcalcab-mcq-b5-sv-h-2.5-a-v2','apcalcab-mcq-b5-sv-h-2.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
