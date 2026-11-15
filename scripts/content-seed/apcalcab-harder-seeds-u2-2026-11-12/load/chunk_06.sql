begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.6-b-v1','apcalcab-mcq-b5-sv-h-2.6-b-v2','apcalcab-mcq-b5-sv-h-2.6-b-v3','apcalcab-mcq-b5-h-2.7-a','apcalcab-mcq-b5-sv-h-2.7-a-v1','apcalcab-mcq-b5-sv-h-2.7-a-v2','apcalcab-mcq-b5-sv-h-2.7-a-v3','apcalcab-mcq-b5-h-2.7-b','apcalcab-mcq-b5-sv-h-2.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-sv-h-2.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.6-b-v1', 'mcq', 'work backward from a given derivative of a combination to the derivative of a component function, using the sum and cons (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function, and let g(x) = 3f(x) + x³. The tangent line to the graph of g at x = 1 has slope 12. What is f′(1)?', null, md5('apcalcab-mcq-b5-sv-h-2.6-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', false, 'This ignores the x³ term and divides 12 by 3 to get 4, but g′(x) = 3f′(x) + 3x² includes 3x² = 3 at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '9', false, 'This subtracts 3 from 12 but forgets to divide by the constant multiple 3. The step 3f′(1) = 9 gives f′(1) = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'Correct: g′(x) = 3f′(x) + 3x², so g′(1) = 3f′(1) + 3 = 12, which gives 3f′(1) = 9 and f′(1) = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'This has a sign error on the x³ term: it solves 3f′(1) − 3 = 12, but the derivative of +x³ is +3x².' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.6-b-v2', 'mcq', 'work backward from a given derivative of a combination to the derivative of a component function, using the sum and cons (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function, and let h(x) = 5x − 2f(x). The graph of h has a horizontal tangent line at x = −1. What is f′(−1)?', null, md5('apcalcab-mcq-b5-sv-h-2.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'This forgets the constant multiple 2: from 5 − 2f′(−1) = 0, f′(−1) = 5/2, not 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5/2', false, 'This has a sign error: it solves 5 + 2f′(−1) = 0, but the derivative of −2f(x) is −2f′(x).' from version_ins
union all select gen_random_uuid(), id, 'C', '2/5', false, 'This inverts the result. Solving 5 − 2f′(−1) = 0 gives f′(−1) = 5/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/2', true, 'Correct: h′(x) = 5 − 2f′(x). A horizontal tangent needs h′(−1) = 5 − 2f′(−1) = 0, so f′(−1) = 5/2.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.6-b-v3', 'mcq', 'work backward from a given derivative of a combination to the derivative of a component function, using the sum and cons (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function, and let p(x) = (1/2)f(x) + 6x². The tangent line to the graph of p at x = 1 has slope −5. What is f′(1)?', null, md5('apcalcab-mcq-b5-sv-h-2.6-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−17', false, 'This forgets to multiply by 2 to undo the constant multiple 1/2. From (1/2)f′(1) = −17, f′(1) = −34.' from version_ins
union all select gen_random_uuid(), id, 'B', '−34', true, 'Correct: p′(x) = (1/2)f′(x) + 12x, so p′(1) = (1/2)f′(1) + 12 = −5, which gives (1/2)f′(1) = −17 and f′(1) = −34.' from version_ins
union all select gen_random_uuid(), id, 'C', '−22', false, 'This differentiates 6x² as 6x instead of 12x, getting (1/2)f′(1) + 6 = −5, so f′(1) = −22.' from version_ins
union all select gen_random_uuid(), id, 'D', '14', false, 'This has a sign error: it solves (1/2)f′(1) − 12 = −5, but the derivative of +6x² is +12x, which is +12 at x = 1.' from version_ins;
-- apcalcab-mcq-b5-h-2.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.7-a', 'mcq', 'find where a tangent line to e^x or ln x passes through a given external point.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of y = eˣ at x = a passes through the origin. What is the value of a?', null, md5('apcalcab-mcq-b5-h-2.7-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 0', false, 'At x = 0 the tangent line is y = 1 + x, which passes through (0, 1), not the origin. The origin''s x-coordinate is not the point of tangency.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = e', false, 'The number e is the value of eˣ at x = 1. It is the y-coordinate of the point of tangency, not the x-coordinate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = −1', false, 'This has a sign error: the tangent y = eᵃ + eᵃ(x − a) passes through (0, 0) when 1 − a = 0, not 1 + a = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 1', true, 'Correct: The tangent at x = a is y = eᵃ + eᵃ(x − a). At x = 0, y = eᵃ(1 − a), which is 0 only when a = 1.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.7-a-v1', 'mcq', 'find where a tangent line to e^x or ln x passes through a given external point. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of y = ln x at x = a passes through the origin. What is the value of a?', null, md5('apcalcab-mcq-b5-sv-h-2.7-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 1', false, 'At x = 1 the tangent is y = x − 1, which crosses the x-axis at x = 1 but passes through (0, −1), not the origin.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 1/e', false, 'This has a sign error. The tangent y = ln a + (x − a)/a passes through (0, 0) when ln a − 1 = 0, so ln a = 1, not −1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = e²', false, 'This gives ln a = 2 instead of ln a = 1, which comes from doubling the 1 contributed by the (x − a)/a term.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = e', true, 'Correct: The tangent at x = a is y = ln a + (x − a)/a. At x = 0 it gives y = ln a − 1, which is 0 when ln a = 1, so a = e.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.7-a-v2', 'mcq', 'find where a tangent line to e^x or ln x passes through a given external point. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of y = eˣ at x = a passes through the point (2, 0). What is the value of a?', null, md5('apcalcab-mcq-b5-sv-h-2.7-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 2', false, 'The number 2 is the x-coordinate of the given point, not the point of tangency. At x = 2 the tangent is y = e²(x − 1), which does not pass through (2, 0).' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 3', true, 'Correct: The tangent at x = a is y = eᵃ + eᵃ(x − a). At the point (2, 0), 0 = eᵃ(1 + 2 − a), so a = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 1', false, 'This has a sign error in the constant: the tangent y = eᵃ(x − a + 1) passes through (2, 0) when 2 − a + 1 = 0. Using 2 − a − 1 = 0 gives a = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = e³', false, 'The number e³ is the y-coordinate of the point of tangency when a = 3, not the x-coordinate a.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.7-a-v3', 'mcq', 'find where a tangent line to e^x or ln x passes through a given external point. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of y = ln x at x = a passes through the point (0, −2). What is the value of a?', null, md5('apcalcab-mcq-b5-sv-h-2.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 1/e', true, 'Correct: At x = 0 the tangent gives y = ln a − 1. Setting ln a − 1 = −2 gives ln a = −1, so a = 1/e.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = e', false, 'This has a sign error: the tangent y = ln a + (x − a)/a passes through (0, −2) when ln a − 1 = −2, so ln a = −1, not 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = e⁻²', false, 'This sets ln a = −2 directly, forgetting the −1 contributed by the (x − a)/a term at x = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = e⁻³', false, 'This solves ln a + 1 = −2, adding 1 instead of subtracting it. At x = 0 the tangent gives ln a − 1.' from version_ins;
-- apcalcab-mcq-b5-h-2.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.7-b', 'mcq', 'differentiate a sum that contains constant-valued exponential, logarithmic and trigonometric terms without treating the ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = eˣ + e²x + ln 3. What is f′(2)?', null, md5('apcalcab-mcq-b5-h-2.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2e² + 1/3', false, 'This differentiates the constant ln 3 as 1/(3). The derivative of any constant, including ln 3, is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'e² + 4e', false, 'This differentiates e²x as 2e · x by treating e² as a variable power. Since e² is a constant, the derivative of e²x is e².' from version_ins
union all select gen_random_uuid(), id, 'C', '2e²', true, 'Correct: f′(x) = eˣ + e² + 0, so f′(2) = e² + e² = 2e².' from version_ins
union all select gen_random_uuid(), id, 'D', '3e²', false, 'This differentiates e²x as e²x, as if it were eˣ. The derivative of a constant times x is just the constant e².' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.7-b-v1', 'mcq', 'differentiate a sum that contains constant-valued exponential, logarithmic and trigonometric terms without treating the  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = ln x + x ln 3 for x > 0. What is g′(3)?', null, md5('apcalcab-mcq-b5-sv-h-2.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/3', false, 'This differentiates x ln 3 as x · (1/3), treating ln 3 as a variable. The derivative is the constant ln 3, which is not 1/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '2/3', false, 'This differentiates x ln 3 as 1/3, applying the logarithm rule to a constant instead of using the constant multiple rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/3 + ln 3', true, 'Correct: g′(x) = 1/x + ln 3, so g′(3) = 1/3 + ln 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/3', false, 'This treats x ln 3 as a constant, dropping it entirely. The derivative of x ln 3 is ln 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.6-b-v1','apcalcab-mcq-b5-sv-h-2.6-b-v2','apcalcab-mcq-b5-sv-h-2.6-b-v3','apcalcab-mcq-b5-h-2.7-a','apcalcab-mcq-b5-sv-h-2.7-a-v1','apcalcab-mcq-b5-sv-h-2.7-a-v2','apcalcab-mcq-b5-sv-h-2.7-a-v3','apcalcab-mcq-b5-h-2.7-b','apcalcab-mcq-b5-sv-h-2.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-sv-h-2.6-b-v1','apcalcab-mcq-b5-sv-h-2.6-b-v2','apcalcab-mcq-b5-sv-h-2.6-b-v3','apcalcab-mcq-b5-h-2.7-a','apcalcab-mcq-b5-sv-h-2.7-a-v1','apcalcab-mcq-b5-sv-h-2.7-a-v2','apcalcab-mcq-b5-sv-h-2.7-a-v3','apcalcab-mcq-b5-h-2.7-b','apcalcab-mcq-b5-sv-h-2.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
